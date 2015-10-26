From: Harsh Jain <harshjain.prof@gmail.com>
Subject: Re: kernel tainted while exporting shash context using af_alg interface
Date: Mon, 26 Oct 2015 14:51:01 +0530
Message-ID: <CAFXBA==5iFOGWrZ+JtM4Yr1XnBL2NFRs=EMoeS4F2mF-R89iqQ@mail.gmail.com>
References: <CAFXBA=mVmRsAk3fuyjf3WA-P+0dHKu0upUdb5Qxr0kwn1rKiDw@mail.gmail.com>
	<2725312.7LhRVP0piv@tauon.atsec.com>
	<CAFXBA==rM=XBykDC+K2tvS=Gya+ykBZp4ySnjQbPcgebOOYZGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a11c3c964d38c680522fe7a81
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:35548 "EHLO
	mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbbJZJVD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 26 Oct 2015 05:21:03 -0400
Received: by lfbn126 with SMTP id n126so105579190lfb.2
        for <linux-crypto@vger.kernel.org>; Mon, 26 Oct 2015 02:21:01 -0700 (PDT)
In-Reply-To: <CAFXBA==rM=XBykDC+K2tvS=Gya+ykBZp4ySnjQbPcgebOOYZGw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

--001a11c3c964d38c680522fe7a81
Content-Type: text/plain; charset=UTF-8

Hi Stephan,

I tried 1 more patch. This time result is correct. Find attached patch
file. Is there any side effect of this patch.


Regards
Harsh Jain

On Mon, Oct 26, 2015 at 11:49 AM, Harsh Jain <harshjain.prof@gmail.com> wrote:
> Hi Stephan,
>
> I also tried test program in libkcapi and it works. libkcapi opens
> socket of type "hmac(sha1)" .Openssl opens multiple "sha1" type socket
> and uses the partial results to calculate hmac.
>
>  "crypto_ahash_init()" function initialises the *tfm variable in
> crypto_shash structure.It gets called when user calls write() system
> call. To give a try I updated the hash_accept() function and re-run.
> This time kernel didn't crashed but result calculated is wrong.
>
> How accept() sys call decide weather to call alg_accept() or hash_accept()?
>
> Find attached patch and strace.Right now af_alg code is not accessible
> to me. I will share it tomorrow.
>
>
>
> Thanks and Regards
> Harsh jain
>
> On Sun, Oct 25, 2015 at 5:28 PM, Stephan Mueller <smueller@chronox.de> wrote:
>> Am Sonntag, 25. Oktober 2015, 11:56:27 schrieb Harsh Jain:
>>
>> Hi Harsh,
>>
>>>Hi,
>>>
>>>
>>>When trying to calculate HMAC(SHA1) with openssl using af-alg engine
>>>kernel crashes.Find below the command used and kernel. I have added
>>>some debug print in logs.
>>>
>>>Command used : ./openssl dgst -engine af_alg -sha1 -hmac "key" r.txt
>>>kernel version : 3.17.8
>>>
>>>Initial Investigation : In shash_desc structure tfm pointer contains
>>>5a5a5a5a5a5a5a5a(invalid pointer), when it triess to reference export
>>>function pointer it crashes. As per my understanding tfm object should
>>>have pointer of memory bloack allocated in
>>>"crypto_init_shash_ops_async" function
>>>
>>>Please give some pointers to debug the issue.Any documentation to
>>>understand the crypto-api code.
>>
>> May I ask you to send 2 things: the source code of the OpenSSL af_alg engine
>> that you use (IIRC it is not included upstream, I want to be sure I used the
>> right one).
>>
>> Further, can you attach an strace of the aforementioned command?
>>
>> Note, I am playing and abusing the AF_ALG interface for quite some time with
>> [1] but I did not come across any issues like the one you describe here.
>>
>> [1] http://www.chronox.de/libkcapi.html
>>
>> Ciao
>> Stephan

--001a11c3c964d38c680522fe7a81
Content-Type: application/octet-stream; name="algif_hash_2.patch"
Content-Disposition: attachment; filename="algif_hash_2.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ig7qi45h2

LS0tIGFsZ2lmX2hhc2hfb3JpZy5jCTIwMTUtMTAtMjUgMTM6Mjc6MjkuMjIwMzgzNjk0IC0wNDAw
CisrKyBhbGdpZl9oYXNoLmMJMjAxNS0xMC0yNiAwNDozODozOC40MjI5MjMzNDcgLTA0MDAKQEAg
LTIxNyw2ICsyMTcsMTMgQEAgc3RhdGljIGludCBoYXNoX2FjY2VwdChzdHJ1Y3Qgc29ja2V0ICpz
bwogCWR1bXBfc3RhY2soKTsJCiAJcHJpbnRrKEtFUk5fREVCVUcgIisrKysrKysrKysrKysrKysr
KysrKysrKysrKysrXG4iKTsKIAorCWlmICghY3R4LT5tb3JlKSB7CisJCWVyciA9IGNyeXB0b19h
aGFzaF9pbml0KCZjdHgtPnJlcSk7CisgICAgICAgICAgICAgICAgaWYgKGVycikgeworCQkJcHJp
bnRrKEtFUk5fREVCVUcgImhhc2hfYWNjZXB0OiBFcnJvciBpbiBjcnlwdG9fYWhhc2hfaW5pdFxu
Iik7ICAgICAgICAKKwkgICAgICAgICAgICAgICAgcmV0dXJuIGVycjsKKwkJfQorCX0KIAllcnIg
PSBjcnlwdG9fYWhhc2hfZXhwb3J0KHJlcSwgc3RhdGUpOwogCWlmIChlcnIpCiAJCXJldHVybiBl
cnI7Cg==
--001a11c3c964d38c680522fe7a81--
