Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5656D44
	for <linux-crypto@vger.kernel.org>; Mon,  4 Dec 2023 23:32:11 -0800 (PST)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0VxtSpGf_1701761527;
Received: from 30.97.48.243(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0VxtSpGf_1701761527)
          by smtp.aliyun-inc.com;
          Tue, 05 Dec 2023 15:32:09 +0800
Message-ID: <d7c7ea8c-6e2f-e8d8-88c3-4952c506ed13@linux.alibaba.com>
Date: Tue, 5 Dec 2023 15:32:06 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: Weird EROFS data corruption
To: Juhyung Park <qkrwngud825@gmail.com>
Cc: Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-crypto@vger.kernel.org,
 Yann Collet <yann.collet.73@gmail.com>
References: <CAD14+f2AVKf8Fa2OO1aAUdDNTDsVzzR6ctU_oJSmTyd6zSYR2Q@mail.gmail.com>
 <5a0e8b44-6feb-b489-cdea-e3be3811804a@linux.alibaba.com>
 <CAD14+f2G-buxTaWgb23DYW-HSd1sch6tJNKV2strt=toASZXQQ@mail.gmail.com>
 <649a3bc4-58bb-1dc8-85fb-a56e47b3d5c9@linux.alibaba.com>
 <CAD14+f1u6gnHLhGSoQxL9wLq9vDYse+Ac8zxep-O2E8hHreT2w@mail.gmail.com>
 <275f025d-e2f1-eaff-6af1-e909d370cee0@linux.alibaba.com>
 <CAD14+f3zgwgUugjnB7UGCYh4j3iXYsvv_DJ3yvwduA1xf3xn=A@mail.gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <CAD14+f3zgwgUugjnB7UGCYh4j3iXYsvv_DJ3yvwduA1xf3xn=A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Juhyung,

On 2023/12/4 11:41, Juhyung Park wrote:

...
> 
>>
>> - Could you share the full message about the output of `lscpu`?
> 
> Sure:
> 
> Architecture:            x86_64
>    CPU op-mode(s):        32-bit, 64-bit
>    Address sizes:         39 bits physical, 48 bits virtual
>    Byte Order:            Little Endian
> CPU(s):                  8
>    On-line CPU(s) list:   0-7
> Vendor ID:               GenuineIntel
>    BIOS Vendor ID:        Intel(R) Corporation
>    Model name:            11th Gen Intel(R) Core(TM) i7-1185G7 @ 3.00GHz
>      BIOS Model name:     11th Gen Intel(R) Core(TM) i7-1185G7 @ 3.00GHz None CPU
>                            @ 3.0GHz
>      BIOS CPU family:     198
>      CPU family:          6
>      Model:               140
>      Thread(s) per core:  2
>      Core(s) per socket:  4
>      Socket(s):           1
>      Stepping:            1
>      CPU(s) scaling MHz:  60%
>      CPU max MHz:         4800.0000
>      CPU min MHz:         400.0000
>      BogoMIPS:            5990.40
>      Flags:               fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mc
>                           a cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss
>                           ht tm pbe syscall nx pdpe1gb rdtscp lm constant_tsc art
>                            arch_perfmon pebs bts rep_good nopl xtopology nonstop_
>                           tsc cpuid aperfmperf tsc_known_freq pni pclmulqdq dtes6
>                           4 monitor ds_cpl vmx smx est tm2 ssse3 sdbg fma cx16 xt
>                           pr pdcm pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_dead
>                           line_timer aes xsave avx f16c rdrand lahf_lm abm 3dnowp
>                           refetch cpuid_fault epb cat_l2 cdp_l2 ssbd ibrs ibpb st
>                           ibp ibrs_enhanced tpr_shadow flexpriority ept vpid ept_
>                           ad fsgsbase tsc_adjust bmi1 avx2 smep bmi2 erms invpcid
>                            rdt_a avx512f avx512dq rdseed adx smap avx512ifma clfl
>                           ushopt clwb intel_pt avx512cd sha_ni avx512bw avx512vl
>                           xsaveopt xsavec xgetbv1 xsaves split_lock_detect dtherm
>                            ida arat pln pts hwp hwp_notify hwp_act_window hwp_epp
>                            hwp_pkg_req vnmi avx512vbmi umip pku ospke avx512_vbmi
>                           2 gfni vaes vpclmulqdq avx512_vnni avx512_bitalg tme av
>                           x512_vpopcntdq rdpid movdiri movdir64b fsrm avx512_vp2i

Sigh, I've been thinking.  Here FSRM is the most significant difference between
our environments, could you only try the following diff to see if there's any
difference anymore? (without the previous disable patch.)

diff --git a/arch/x86/lib/memmove_64.S b/arch/x86/lib/memmove_64.S
index 1b60ae81ecd8..1b52a913233c 100644
--- a/arch/x86/lib/memmove_64.S
+++ b/arch/x86/lib/memmove_64.S
@@ -41,9 +41,7 @@ SYM_FUNC_START(__memmove)
  #define CHECK_LEN	cmp $0x20, %rdx; jb 1f
  #define MEMMOVE_BYTES	movq %rdx, %rcx; rep movsb; RET
  .Lmemmove_begin_forward:
-	ALTERNATIVE_2 __stringify(CHECK_LEN), \
-		      __stringify(CHECK_LEN; MEMMOVE_BYTES), X86_FEATURE_ERMS, \
-		      __stringify(MEMMOVE_BYTES), X86_FEATURE_FSRM
+	CHECK_LEN
  
  	/*
  	 * movsq instruction have many startup latency

Thanks,
Gao Xiang
