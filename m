Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1BCA295DBD;
	Wed,  5 Nov 2025 08:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762330631; cv=none; b=qN8s4zoC9u87ZRpMYdqs/I03NQOX6/Yhh3B84RCHI+n5AhRPYB58I4TNsGOFtpqq+Kq2UyE19cmoWil/v4WNmg7LR/n1Wv7xXSLnAIhbSzZANQB8a8OEovYwiI6U5SOp9h2dwQIozKTw1xnAnqNiRPZBruQohCIk8E/1r/c0pkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762330631; c=relaxed/simple;
	bh=ua/670dEMZVgx9bSxALVpDEyNED/216HV6az4zsxl/c=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=hp9gPoQNtms+3lXgbECRlDblJmTgQ0OHTkSvFJMGfKrdFgDFE0O8YpZD70UfJ/KXzCpt/mzE23ErgdHxBqtD9WhvFBbHRSB5s7SlaKuGjyb9K1RcXQAbvLL4GXw7haEeMRiYGwBIFToNBTXEDa3Xgn293trLo4n46OlGRz+00Aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=CgZgBBqy; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="CgZgBBqy"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A52RI1Z026493;
	Wed, 5 Nov 2025 08:16:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=pp1;
	 bh=s+5STQiedTkkBZfdZVWrZUEqJP58615+ORN4NGsJkx0=; b=CgZgBBqy443y
	sY5evTdzSwfmByH19x5ltAA5PWtHIueqEmzseeyYjeKWOnrGzztJPHKJOmj78PAD
	efxgggS8ogtVIzS9imp/nGNqhJyM2ktzTFB/DCWC1ETa+gUX9G/28nF8zQC1TgWa
	Ez+8T1GPqZDf7VN7i8jAKyxkdnWHmQ2OgD6ZToBmZRSef7gzXf8V3hdxG+V28n3Q
	IjnHyEHnhuSWMuowmhDcrj/64mbRryCGCrh59oXP2iNc69ar865pZ5sAh+GJIbrL
	9Q64qceirSTH5//o0vWoXSEtIeEA8EC6kHaIDxS7WL4NaBCAUE2pD28wv2PSny9T
	nGMra7e3eA==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a59v1yt17-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Nov 2025 08:16:59 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5A56mji1025588;
	Wed, 5 Nov 2025 08:16:58 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4a5vhsqafu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Nov 2025 08:16:58 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5A58GvVc64225788
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 5 Nov 2025 08:16:57 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2E6995803F;
	Wed,  5 Nov 2025 08:16:57 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9D52F58056;
	Wed,  5 Nov 2025 08:16:56 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  5 Nov 2025 08:16:56 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 05 Nov 2025 09:16:56 +0100
From: Harald Freudenberger <freude@linux.ibm.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Ard
 Biesheuvel <ardb@kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Holger Dengler <dengler@linux.ibm.com>,
        Herbert Xu
 <herbert@gondor.apana.org.au>,
        linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/15] SHA-3 library
Reply-To: freude@linux.ibm.com
Mail-Reply-To: freude@linux.ibm.com
In-Reply-To: <20251104182738.GA2419@sol>
References: <20251026055032.1413733-1-ebiggers@kernel.org>
 <ba3ff3d5183ab78b3d02d8db30223def@linux.ibm.com> <20251029163216.GA1603@sol>
 <fa8bc10f36b1aeb9ffe1abf6350adbc1@linux.ibm.com> <20251030171453.GA1624@sol>
 <c39f6b6c110def0095e5da5becc12085@linux.ibm.com> <20251104182738.GA2419@sol>
Message-ID: <70461134f12796b1166978c8628b5cf3@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3cSBYsQDAYYlgB92Vh8do0Svxw9CzUFf
X-Proofpoint-ORIG-GUID: 3cSBYsQDAYYlgB92Vh8do0Svxw9CzUFf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTAxMDAyMSBTYWx0ZWRfX2Qk0c/WbAtrg
 T6Ulspt3JNVc+F3EHppWNFkTWNHYi3x7rBS3WrsD93mTbSRs48lxvUoOpVf9GjuDVHG27KxQ5cF
 qgkaWOEys7mf54mKioHD+5s2X7M3ct4LMHP7PmVVxQb6BZtP6rFbcKrtOXbiclR5zT0f8NjrIS0
 I0kB+L/5lbHhHKYt88J+ld87p3HQAJu5L2DmOOs5mK1d1yBHnlZtifMeE8Q1gBhu/IIWKVVDYxU
 +rp2hwOOeeEfgK39W9UMMCh/yYGLQSUtu2HhLV1rFWHNRH7ylEr+CwEG3Gnu3WMsQgO781+Gs/9
 I5t5wFKuWRLCXcK6LuY+UvYVUXCri5SyjpL/q9TINMI+V3RJeVtbrUnzzYUfblSjV2OdryIvwy7
 s30e6gPCDUK7MD+9rT+1+3KQMy7Y1w==
X-Authority-Analysis: v=2.4 cv=H8HWAuYi c=1 sm=1 tr=0 ts=690b07fb cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=5X5LY1NTxJEeGDfTEVgA:9 a=CjuIK1q_8ugA:10 a=V-P4VFR5b4V6Rcv5HO6H:22
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-05_03,2025-11-03_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 lowpriorityscore=0 priorityscore=1501 adultscore=0
 impostorscore=0 clxscore=1015 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511010021

On 2025-11-04 19:27, Eric Biggers wrote:
> On Tue, Nov 04, 2025 at 12:07:40PM +0100, Harald Freudenberger wrote:
>> > Thanks!  Is this with the whole series applied?  Those numbers are
>> > pretty fast, so probably at least the Keccak acceleration part is
>> > worthwhile.  But just to reiterate what I asked for:
>> >
>> >     Also, it would be helpful to provide the benchmark output from just
>> >     before "lib/crypto: s390/sha3: Add optimized Keccak function", just
>> >     after it, and after "lib/crypto: s390/sha3: Add optimized one-shot
>> >     SHA-3 digest functions".
>> >
>> > So I'd like to see how much each change helped, which isn't clear if you
>> > show only the result at the end.
>> >
>> > If there's still no evidence that "lib/crypto: s390/sha3: Add optimized
>> > one-shot SHA-3 digest functions" actually helps significantly vs. simply
>> > doing the Keccak acceleration, then we should drop it for simplicity.
> [...]
>> commit b2e169dd8ca5 lib/crypto: s390/sha3: Add optimized one-shot 
>> SHA-3
>> digest functions:
>> 
>> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     # module: sha3_kunit
>> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     1..21
>> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     ok 1 
>> test_hash_test_vectors
>> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     ok 2
>> test_hash_all_lens_up_to_4096
>> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     ok 3
>> test_hash_incremental_updates
>> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     ok 4
>> test_hash_buffer_overruns
>> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     ok 5 test_hash_overlaps
>> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     ok 6
>> test_hash_alignment_consistency
>> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     ok 7
>> test_hash_ctx_zeroization
>> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     ok 8
>> test_hash_interrupt_context_1
>> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     ok 9
>> test_hash_interrupt_context_2
>> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     ok 10 
>> test_sha3_224_basic
>> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     ok 11 
>> test_sha3_256_basic
>> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     ok 12 
>> test_sha3_384_basic
>> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     ok 13 
>> test_sha3_512_basic
>> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     ok 14 
>> test_shake128_basic
>> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     ok 15 
>> test_shake256_basic
>> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     ok 16 
>> test_shake128_nist
>> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     ok 17 
>> test_shake256_nist
>> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     ok 18
>> test_shake_all_lens_up_to_4096
>> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     ok 19
>> test_shake_multiple_squeezes
>> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     ok 20
>> test_shake_with_guarded_bufs
>> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     # benchmark_hash: 
>> len=1: 12
>> MB/s
>> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     # benchmark_hash: 
>> len=16: 80
>> MB/s
>> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     # benchmark_hash: 
>> len=64: 785
>> MB/s
>> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     # benchmark_hash: 
>> len=127:
>> 812 MB/s
>> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     # benchmark_hash: 
>> len=128:
>> 1619 MB/s
>> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     # benchmark_hash: 
>> len=200:
>> 2319 MB/s
>> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     # benchmark_hash: 
>> len=256:
>> 2176 MB/s
>> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     # benchmark_hash: 
>> len=511:
>> 4881 MB/s
>> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     # benchmark_hash: 
>> len=512:
>> 4968 MB/s
>> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     # benchmark_hash: 
>> len=1024:
>> 7565 MB/s
>> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     # benchmark_hash: 
>> len=3173:
>> 11909 MB/s
>> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     # benchmark_hash: 
>> len=4096:
>> 10378 MB/s
>> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     # benchmark_hash: 
>> len=16384:
>> 12273 MB/s
>> Nov 04 10:50:50 b3545008.lnxne.boe kernel:     ok 21 benchmark_hash
>> Nov 04 10:50:50 b3545008.lnxne.boe kernel: # sha3: pass:21 fail:0 
>> skip:0
>> total:21
>> 
>> commit 02266b8a383e lib/crypto: s390/sha3: Add optimized Keccak 
>> functions:
>> 
>> Nov 04 10:55:37 b3545008.lnxne.boe kernel:     # module: sha3_kunit
>> Nov 04 10:55:37 b3545008.lnxne.boe kernel:     1..21
>> Nov 04 10:55:37 b3545008.lnxne.boe kernel:     ok 1 
>> test_hash_test_vectors
>> Nov 04 10:55:37 b3545008.lnxne.boe kernel:     ok 2
>> test_hash_all_lens_up_to_4096
>> Nov 04 10:55:37 b3545008.lnxne.boe kernel:     ok 3
>> test_hash_incremental_updates
>> Nov 04 10:55:37 b3545008.lnxne.boe kernel:     ok 4
>> test_hash_buffer_overruns
>> Nov 04 10:55:37 b3545008.lnxne.boe kernel:     ok 5 test_hash_overlaps
>> Nov 04 10:55:37 b3545008.lnxne.boe kernel:     ok 6
>> test_hash_alignment_consistency
>> Nov 04 10:55:37 b3545008.lnxne.boe kernel:     ok 7
>> test_hash_ctx_zeroization
>> Nov 04 10:55:38 b3545008.lnxne.boe kernel:     ok 8
>> test_hash_interrupt_context_1
>> Nov 04 10:55:38 b3545008.lnxne.boe kernel:     ok 9
>> test_hash_interrupt_context_2
>> Nov 04 10:55:38 b3545008.lnxne.boe kernel:     ok 10 
>> test_sha3_224_basic
>> Nov 04 10:55:38 b3545008.lnxne.boe kernel:     ok 11 
>> test_sha3_256_basic
>> Nov 04 10:55:38 b3545008.lnxne.boe kernel:     ok 12 
>> test_sha3_384_basic
>> Nov 04 10:55:38 b3545008.lnxne.boe kernel:     ok 13 
>> test_sha3_512_basic
>> Nov 04 10:55:38 b3545008.lnxne.boe kernel:     ok 14 
>> test_shake128_basic
>> Nov 04 10:55:38 b3545008.lnxne.boe kernel:     ok 15 
>> test_shake256_basic
>> Nov 04 10:55:38 b3545008.lnxne.boe kernel:     ok 16 
>> test_shake128_nist
>> Nov 04 10:55:38 b3545008.lnxne.boe kernel:     ok 17 
>> test_shake256_nist
>> Nov 04 10:55:38 b3545008.lnxne.boe kernel:     ok 18
>> test_shake_all_lens_up_to_4096
>> Nov 04 10:55:38 b3545008.lnxne.boe kernel:     ok 19
>> test_shake_multiple_squeezes
>> Nov 04 10:55:38 b3545008.lnxne.boe kernel:     ok 20
>> test_shake_with_guarded_bufs
>> Nov 04 10:55:38 b3545008.lnxne.boe kernel:     # benchmark_hash: 
>> len=1: 12
>> MB/s
>> Nov 04 10:55:38 b3545008.lnxne.boe kernel:     # benchmark_hash: 
>> len=16: 211
>> MB/s
>> Nov 04 10:55:38 b3545008.lnxne.boe kernel:     # benchmark_hash: 
>> len=64: 835
>> MB/s
>> Nov 04 10:55:38 b3545008.lnxne.boe kernel:     # benchmark_hash: 
>> len=127:
>> 1557 MB/s
>> Nov 04 10:55:38 b3545008.lnxne.boe kernel:     # benchmark_hash: 
>> len=128:
>> 1617 MB/s
>> Nov 04 10:55:38 b3545008.lnxne.boe kernel:     # benchmark_hash: 
>> len=200:
>> 1457 MB/s
>> Nov 04 10:55:38 b3545008.lnxne.boe kernel:     # benchmark_hash: 
>> len=256:
>> 1830 MB/s
>> Nov 04 10:55:38 b3545008.lnxne.boe kernel:     # benchmark_hash: 
>> len=511:
>> 3035 MB/s
>> Nov 04 10:55:38 b3545008.lnxne.boe kernel:     # benchmark_hash: 
>> len=512:
>> 3245 MB/s
>> Nov 04 10:55:38 b3545008.lnxne.boe kernel:     # benchmark_hash: 
>> len=1024:
>> 5319 MB/s
>> Nov 04 10:55:38 b3545008.lnxne.boe kernel:     # benchmark_hash: 
>> len=3173:
>> 9969 MB/s
>> Nov 04 10:55:38 b3545008.lnxne.boe kernel:     # benchmark_hash: 
>> len=4096:
>> 11123 MB/s
>> Nov 04 10:55:38 b3545008.lnxne.boe kernel:     # benchmark_hash: 
>> len=16384:
>> 12767 MB/s
>> Nov 04 10:55:38 b3545008.lnxne.boe kernel:     ok 21 benchmark_hash
>> Nov 04 10:55:38 b3545008.lnxne.boe kernel: # sha3: pass:21 fail:0 
>> skip:0
>> total:21
> 
> Thanks.  So the results before and after "lib/crypto: s390/sha3: Add
> optimized one-shot SHA-3 digest functions" are:
> 
>     Length (bytes)      Before            After
>     ==============    ==========        ==========
>          1               12 MB/s           12 MB/s
>         16              211 MB/s           80 MB/s
>         64              835 MB/s          785 MB/s
>        127             1557 MB/s          812 MB/s
>        128             1617 MB/s         1619 MB/s
>        200             1457 MB/s         2319 MB/s
>        256             1830 MB/s         2176 MB/s
>        511             3035 MB/s         4881 MB/s
>        512             3245 MB/s         4968 MB/s
>       1024             5319 MB/s         7565 MB/s
>       3173             9969 MB/s        11909 MB/s
>       4096            11123 MB/s        10378 MB/s
>      16384            12767 MB/s        12273 MB/s
> 
> Unfortunately that seems inconclusive.  len=200, 256, 511, 512, 1024,
> 3173 improved.  But len=16, 64, 127, 4096, 16384 regressed.
> 
> I expected the most improvement on short lengths.  The fact that some 
> of
> the short lengths actually regressed is concerning.
> 
> It's also clear the the Keccak acceleration itself matters far more 
> than
> this additional one-shot optimization, as expected.  The generic code
> maxed out at only 259 MB/s for you.
> 
> I suggest we hold off on "lib/crypto: s390/sha3: Add optimized one-shot
> SHA-3 digest functions" for now, to avoid the extra maintainence cost
> and opportunity for bugs.
> 
> If you can provide more accurate numbers that show it's worthwhile, we
> can reconsider.  Maybe set the CPU to a fixed frequency, and run
> sha3_kunit multiple times (triggered via KUnit's debugfs interface)?
> 
> - Eric

The focus should be on the small data. Let me see what I can do ...
I used a zVM guest for this. Instead use an LPAR may be an option and
some CPU pinning. And do some more tests to be able to calculate a gauss
distribution. However, not within the next few days.
So I agree with you: let's hold back the one-shot optimization.

Harald Freudenberger
