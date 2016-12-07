From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v3 1/6] crypto: testmgr - avoid overlap in chunked tests
Date: Wed, 7 Dec 2016 19:53:51 +0000
Message-ID: <CAKv+Gu_HUjCparJnZXzZR=m3obt+aypibpHrP_ivA==1QNYksg@mail.gmail.com>
References: <1480963348-24203-1-git-send-email-ard.biesheuvel@linaro.org>
 <1480963348-24203-2-git-send-email-ard.biesheuvel@linaro.org> <20161207191920.GA139213@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:32891 "EHLO
        mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932548AbcLGTxw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Dec 2016 14:53:52 -0500
Received: by mail-io0-f180.google.com with SMTP id j65so730445893iof.0
        for <linux-crypto@vger.kernel.org>; Wed, 07 Dec 2016 11:53:52 -0800 (PST)
In-Reply-To: <20161207191920.GA139213@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 7 December 2016 at 19:19, Eric Biggers <ebiggers@google.com> wrote:
> On Mon, Dec 05, 2016 at 06:42:23PM +0000, Ard Biesheuvel wrote:
>> The IDXn offsets are chosen such that tap values (which may go up to
>> 255) end up overlapping in the xbuf allocation. In particular, IDX1
>> and IDX3 are too close together, so update IDX3 to avoid this issue.
>>
>
> Hi Ard,
>
> This patch is causing the self-tests for "xts(ecb(aes-asm))" to fail.
> This is on x86.  Any idea why?

Does this help at all?

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 670893bcf361..59e67f5b544b 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -63,7 +63,7 @@ int alg_test(const char *driver, const char *alg,
u32 type, u32 mask)
  */
 #define IDX1           32
 #define IDX2           32400
-#define IDX3           511
+#define IDX3           1511
 #define IDX4           8193
 #define IDX5           22222
 #define IDX6           17101


>  Here's what I see in the log:
>
>         alg: skcipher: Chunk test 1 failed on encryption at page 0 for xts(ecb(aes-asm))
>         00000000: 1c 3b 3a 10 2f 77 03 86 e4 83 6c 99 e3 70 cf 9b
>         00000010: ea 00 80 3f 5e 48 23 57 a4 ae 12 d4 14 a3 e6 3b
>         00000020: 5d 31 e2 76 f8 fe 4a 8d 66 b3 17 f9 ac 68 3f 44
>         00000030: 68 0a 86 ac 35 ad fc 33 45 be fe cb 4b b1 88 fd
>         00000040: 57 76 92 6c 49 a3 09 5e b1 08 fd 10 98 ba ec 70
>         00000050: aa a6 69 99 a7 2a 82 f2 7d 84 8b 21 d4 a7 41 b0
>         00000060: c5 cd 4d 5f ff 9d ac 89 ae ba 12 29 61 d0 3a 75
>         00000070: 71 23 e9 87 0f 8a cf 10 00 02 08 87 89 14 29 ca
>         00000080: 2a 3e 7a 7d 7d f7 b1 03 55 16 5c 8b 9a 6d 0a 7d
>         00000090: e8 b0 62 c4 50 0d c4 cd 12 0c 0f 74 18 da e3 d0
>         000000a0: b5 78 1c 34 80 3f a7 54 21 c7 90 df e1 de 18 34
>         000000b0: f2 80 d7 66 7b 32 7f 6c 8c d7 55 7e 12 ac 3a 0f
>         000000c0: 93 ec 05 c5 2e 04 93 ef 31 a1 2d 3d 92 60 f7 9a
>         000000d0: 28 9d 6a 37 9b c7 0c 50 84 14 73 d1 a8 cc 81 ec
>         000000e0: 58 3e 96 45 e0 7b 8d 96 70 65 5b a5 bb cf ec c6
>         000000f0: dc 39 66 38 0a d8 fe cb 17 b6 ba 02 46 9a 02 0a
>         00000100: 84 e1 8e 8f 84 25 20 70 c1 3e 9f 1f 28 9b e5 4f
>         00000110: bc 48 14 57 77 8f 61 60 15 e1 32 7a 02 b1 40 f1
>         00000120: 50 5e b3 09 32 6d 68 37 8f 83 74 59 5c 84 9d 84
>         00000130: f4 c3 33 ec 44 23 88 51 43 cb 47 bd 71 c5 ed ae
>         00000140: 9b e6 9a 2f fe ce b1 be c9 de 24 4f be 15 99 2b
>         00000150: 11 b7 7c 04 0f 12 bd 8f 6a 97 5a 44 a0 f9 0c 29
>         00000160: a9 ab c3 d4 d8 93 92 72 84 c5 87 54 cc e2 94 52
>         00000170: 9f 86 14 dc d2 ab a9 91 92 5f ed c4 ae 74 ff ac
>         00000180: 6e 33 3b 93 eb 4a ff 04 79 da 9a 41 0e 44 50 e0
>         00000190: dd 7a e4 c6 e2 91 09 00 57 5d a4 01 fc 07 05 9f
>         000001a0: 64 5e 8b 7e 9b fd ef 33 94 30 54 ff 84 01 14 93
>         000001b0: c2 7b 34 29 ea ed b4 ed 53 76 44 1a 77 ed 43 85
>         000001c0: 1a d7 7f 16 f5 41 df d2 69 d5 0d 6a 5f 14 fb 0a
>         000001d0: 1e 2a 8f 42 61 9e 5e c2 59 bd 96 d0 e5 cc 23 1f
>         000001e0: fb 84 ed 15 a8 eb 66 07 31 6b f6 ef
>
> Eric
