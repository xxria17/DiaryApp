package com.example.myapplication.Fragment;

import android.os.Bundle;

import androidx.fragment.app.Fragment;
import androidx.recyclerview.widget.RecyclerView;

import android.util.Log;
import android.view.GestureDetector;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.example.myapplication.Adapter.DiaryAdapter;
import com.example.myapplication.Model.DiaryContent;
import com.example.myapplication.R;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.firestore.CollectionReference;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.firestore.QueryDocumentSnapshot;
import com.google.firebase.firestore.QuerySnapshot;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static androidx.constraintlayout.widget.Constraints.TAG;


public class PrivateDateFirstFragment extends Fragment {

    private RecyclerView mDateList;
    private FirebaseAuth firebaseAuth;
    private  FirebaseFirestore firebaseFirestore;
    List<DiaryContent> diaryContentList;
    private GestureDetector gestureDetector;
    private DiaryAdapter mDiaryAdaptor;
    private TextView titleTextview, contentTextview, timeTextview;
    Map<String, Object> contentMap;

    RecyclerView.LayoutManager layoutManager;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view =  inflater.inflate(R.layout.fragment_private_date_first, container, false);

        init();
        read_diary();
//        select_diary();

//        layoutManager = new LinearLayoutManager(getActivity());
//        mDateList.setLayoutManager(layoutManager);
//        mDateList.addItemDecoration(new DividerItemDecoration(view.getContext(),1));


        return view;
    }

    private void init(){
        mDateList = (RecyclerView) getActivity().findViewById(R.id.date_first_list);

        titleTextview = (TextView) getActivity().findViewById(R.id.diary_item_title);
        contentTextview = (TextView) getActivity().findViewById(R.id.diary_item_content);
        timeTextview = (TextView) getActivity().findViewById(R.id.diary_item_date);
    }

    private void read_diary(){

        firebaseFirestore = FirebaseFirestore.getInstance();
        firebaseAuth = FirebaseAuth.getInstance();

        FirebaseUser user = firebaseAuth.getCurrentUser();


        //일기 불러오기
        CollectionReference collectionReference = firebaseFirestore.collection("Content");
        collectionReference.whereEqualTo("show",true).get().addOnCompleteListener(task -> {
            DiaryContent diaryData = new DiaryContent();
            if(task.isSuccessful()){
                QuerySnapshot documentSnapshots = task.getResult();
                diaryContentList = new ArrayList<>();
                contentMap = new HashMap<String, Object>();
                for(QueryDocumentSnapshot document : documentSnapshots) {
                    contentMap = document.getData();

                    diaryData.title = (String) contentMap.getOrDefault("title","제목");
                    diaryData.content = (String) contentMap.getOrDefault("content","내용");
//                    diary.timestamp = (Date)contentMap.getOrDefault("timestamp",0);

//                    diaryContentList.add(contentMap);


//                    mDiaryAdaptor.addContent(diary);
                    Log.i(TAG, contentMap.toString());
                }
//                mDiaryAdaptor = new DiaryAdapter(diaryContentList);
                mDateList.setAdapter(mDiaryAdaptor);
            } else{
                Log.d(TAG, "get failed with ", task.getException());
            }
        });

    }

    private void select_diary() {

        //일기 선택
//        gestureDetector = new GestureDetector(getActivity().getApplicationContext(), new GestureDetector.SimpleOnGestureListener(){
//            @Override
//            public boolean onSingleTapUp(MotionEvent e){
//                return true;
//            }
//        });
//
//        //리스트에서 선택한 일기 보내주기
//        mDateList.addOnItemTouchListener(new DiaryFragment.RecyclerTouchListener(getActivity().getApplicationContext(), mDateList, new DiaryFragment.ClickListener() {
//            @Override
//            public void onClick(View view, int position) {
//                Intent diaryIntent = new Intent(getActivity().getBaseContext(), DetailActivity.class);
//                diaryIntent.putExtra("Content", contentMap.get(position));
//                startActivity(diaryIntent);
//            }
//
//
//            //일기 삭제하기
//            @Override
//            public void onLongClick(View view, int position) {
//                AlertDialog.Builder alert = new AlertDialog.Builder(getActivity());
//                alert.setTitle("삭제하겠습니까?");
//                alert.setMessage("삭제된 일기는 복구할 수 없습니다.");
//                alert.setPositiveButton("삭제", new DialogInterface.OnClickListener() {
//                    @Override
//                    public void onClick(DialogInterface dialog, int which) {
//                        firebaseFirestore.collection("diarys").document()
//                                .delete()
//                                .addOnSuccessListener(new OnSuccessListener<Void>() {
//                                    @Override
//                                    public void onSuccess(Void aVoid) {
//                                        Toast.makeText(getActivity(),"삭제되었습니다",Toast.LENGTH_SHORT).show();
//                                    }
//                                })
//                                .addOnFailureListener(new OnFailureListener() {
//                                    @Override
//                                    public void onFailure(@NonNull Exception e) {
//                                        Toast.makeText(getActivity(),"실패",Toast.LENGTH_SHORT).show();
//                                    }
//                                });
//                    }
//                });
//                alert.setNegativeButton("취소", new DialogInterface.OnClickListener() {
//                    @Override
//                    public void onClick(DialogInterface dialog, int which) {
//                        dialog.cancel();
//                    }
//                }).show();
//            }
//        }));
//
//    }
    }
}
