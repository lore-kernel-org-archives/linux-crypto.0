Return-Path: <SRS0=y31I=WC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADBB1C433FF
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Aug 2019 18:34:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F4962086D
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Aug 2019 18:34:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hGgZAmjD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732780AbfHFSev (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Aug 2019 14:34:51 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33413 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728836AbfHFSev (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Aug 2019 14:34:51 -0400
Received: by mail-wr1-f67.google.com with SMTP id n9so88980181wru.0
        for <linux-crypto@vger.kernel.org>; Tue, 06 Aug 2019 11:34:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CI9j1og32UjyhgiHPcwb7Ud6XFvku0B2Oz7BksyYGQs=;
        b=hGgZAmjD1omOOURPQFn3sCZFJBvFZ0CqGqT8WIXRXpyuXI1eZMDR0a0lpFLGVYcvqz
         giGsweNDkbLS8o+puCAyOn6Kw1QZcfdprH5zegE5XT6dG8jJ2HPf0OQ2UphoMvoiS3IK
         O/6ABp5FLD0Nm10615g6mOxnI0nQs8vAUaGUWVVFIHXGwdxdLwL1ftXrQVoee7RVWrKv
         ORVuZWZO/DgEfpTzUkUs+5sS9jdxunlaAv8r3hPqgxJ49jAvum3ge2y4EyNxjqoeaAKI
         Lj9zg8u5KrEzFeNt+e/MCUx5vNCk6vKRli+3cMCQinqvMoyKLh34Ldrf6mloOFdtPxCe
         KUtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CI9j1og32UjyhgiHPcwb7Ud6XFvku0B2Oz7BksyYGQs=;
        b=VyxUB4vadPO9l/z1k0Rkhu2qgWLpB8HL/ujH1otLZ3shjm4OR1qSO77IFzvX3I8Dnx
         M5srlD3I7suMY9PESYuu/A1BBZPkkUnFu0PbszzUaH+eTbPcu9Aye+1GXyfdgP64ftir
         emrKVm4sOkL2QPHo7ZcKYmxuPnpNKr4k+hQeaBOPc3cqCYAdFpRbEzfKg1O5xrjtay06
         ffFsjWuWTI6UXZwEQF6haQ8VO/yyKO6M+ykmxbS2/ztq0YZuSeYGzoNg5yB6FrWjZwMF
         WrdPGyctuyI41UztSmC4i6ib9udaR5+odkEhTuyZ9RgQyi039hGVTkOHZhgeLxqx43xZ
         IPKQ==
X-Gm-Message-State: APjAAAXgr3lGeaoYI+xz+VooiBNRzQFuZzKO/+xDsWcGQiskW2bTk2Ny
        V4EviVdzDVu9nheQ0HSTwYI=
X-Google-Smtp-Source: APXvYqycXMF9cJmto2rqd1KTC2jJI8FiBkqWWlUuvUN0jPj/uL+vkClCghViV213It/Pm1gKD1dEpg==
X-Received: by 2002:a5d:4101:: with SMTP id l1mr6332385wrp.202.1565116488286;
        Tue, 06 Aug 2019 11:34:48 -0700 (PDT)
Received: from [192.168.2.28] (39.35.broadband4.iol.cz. [85.71.35.39])
        by smtp.gmail.com with ESMTPSA id g2sm79751259wmh.0.2019.08.06.11.34.47
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Aug 2019 11:34:47 -0700 (PDT)
Subject: Re: [PATCH] crypto: xts - Add support for Cipher Text Stealing
To:     Pascal van Leeuwen <pascalvanl@gmail.com>,
        linux-crypto@vger.kernel.org
Cc:     rsnel@cube.dyndns.org, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
References: <1565074510-8480-1-git-send-email-pvanleeuwen@verimatrix.com>
From:   Milan Broz <gmazyland@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <5bf9d0be-3ba4-8903-f1b9-93aa32106274@gmail.com>
Date:   Tue, 6 Aug 2019 20:34:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1565074510-8480-1-git-send-email-pvanleeuwen@verimatrix.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 06/08/2019 08:55, Pascal van Leeuwen wrote:
> This adds support for Cipher Text Stealing for data blocks that are not an
> integer multiple of the cipher block size in size, bringing it fully in
> line with the IEEE P1619/D16 standard.
> 
> This has been tested with the AES-XTS test vectors from the IEEE P1619/D16
> specification as well as some additional test vectors supplied to the
> linux_crypto mailing list previously. It has also been fuzzed against
> Inside Secure AES-XTS hardware which has been actively used in the field
> for more than a decade already.
> 
> Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>

Wow, it was quick... thanks for this! :)

I tried to test with my wrapper through AF_ALG (with the discussed test vectors),
but it crashed my 32bit i686 VM (Linus tree with your patch applied)

To reproduce it, run this "kernel" af_alg branch of extracted cryptsetup vector testsuite:
https://github.com/mbroz/cryptsetup_backend_test/tree/kernel

(output) ...
CIPHER vector 00: [aes-ecb,128bits][serpent-ecb,128bits]
CIPHER vector 01: [aes-cbc,128bits][serpent-cbc,128bits]
CIPHER vector 02: [aes-ecb,256bits][serpent-ecb,256bits]
CIPHER vector 03: [aes-cbc,256bits][serpent-cbc,256bits]
CIPHER vector 04: [aes-xts,256bits][serpent-xts,256bits]
CIPHER vector 05: [aes-xts,512bits][serpent-xts,512bits]
CIPHER vector 06: [xchacha12,aes-adiantum,256bits][xchacha20,aes-adiantum,256bits]
Segmentation fault


(If you cannot reproduce it, I'll check it tomorrow. It is quite possible
I have a bug in wrapper, but it should definitely not OOPS the kernel...
moreover, this crash is possible from a user context)

Thanks,
Milan


OOPS log here:

kernel: detected buffer overflow in memcpy
kernel: ------------[ cut here ]------------
kernel: kernel BUG at lib/string.c:1115!
kernel: invalid opcode: 0000 [#1] PREEMPT SMP
kernel: CPU: 1 PID: 2303 Comm: tst Not tainted 5.3.0-rc3+ #572
kernel: Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 04/13/2018
kernel: EIP: fortify_panic+0xe/0x19
kernel: Code: b6 00 00 00 00 8b 45 e4 83 c4 10 5b 5e 29 f8 5f 5d c3 0f b6 c2 0f b6 f3 29 f0 eb ce 55 89 e5 50 68 70 03 8d c1 e8 cc 27 a6 ff <0f> 0b 90 90 90 90 90 90 90 90 90 55 89 e5 57 56 53 89 d3 83 ec 04
kernel: EAX: 00000022 EBX: f1418dc8 ECX: f40ab784 EDX: 00000001
kernel: ESI: f317a318 EDI: 00000020 EBP: f0c2bdf4 ESP: f0c2bdec
kernel: DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00010286
kernel: CR0: 80050033 CR2: b7f543a0 CR3: 30e2a000 CR4: 00140690
kernel: Call Trace:
kernel:  encrypt_finish_cts.cold+0xa/0xa
kernel:  encrypt+0xe7/0x100
kernel:  crypto_skcipher_encrypt+0xe/0x20
kernel:  skcipher_recvmsg+0x2f5/0x390 [algif_skcipher]
kernel:  sock_read_iter+0x86/0xd0
kernel:  __vfs_read+0x140/0x1f0
kernel:  vfs_read+0x8b/0x150
kernel:  ksys_read+0x5c/0xd0
kernel:  sys_read+0x11/0x20
kernel:  do_int80_syscall_32+0x4b/0x1a0
kernel:  entry_INT80_32+0xfb/0xfb
kernel: EIP: 0xb7f64092
kernel: Code: 00 00 00 e9 90 ff ff ff ff a3 24 00 00 00 68 30 00 00 00 e9 80 ff ff ff ff a3 2c 00 00 00 66 90 00 00 00 00 00 00 00 00 cd 80 <c3> 8d b4 26 00 00 00 00 8d b6 00 00 00 00 8b 1c 24 c3 8d b4 26 00
kernel: EAX: ffffffda EBX: 00000004 ECX: bfde1d3c EDX: 00000025
kernel: ESI: b7f57000 EDI: 00000000 EBP: bfde1cb8 ESP: bfde1bcc
kernel: DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b EFLAGS: 00000282
kernel: Modules linked in: nhpoly1305 chacha_generic adiantum poly1305_generic serpent_sse2_i586 serpent_generic glue_helper algif_skcipher rmd160 wp512 sha512_generic sha1_generic algif_hash af_alg loop dm_mod pktcdvd crc32_pclmul crc32c_intel aesni_intel aes_i586 crypto_simd cryptd ata_piix
kernel: ---[ end trace 29d18b04feffc139 ]---

