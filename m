From: Stephan Mueller <smueller@chronox.de>
Subject: Re: md5sum (from libkcapi) fails on kernel 4.9 but not on 4.13
Date: Tue, 17 Oct 2017 15:42:31 +0200
Message-ID: <3299215.QY4dUA6yAn@tauon.chronox.de>
References: <5c552c4b-c05e-7098-6e60-fdc6f7ed5d4b@c-s.fr> <64a7edb0-b9c0-32cd-cc6e-096f2911d5bc@c-s.fr> <3fc056b8-690c-6cec-3af6-0e6d55f4628c@c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Christophe LEROY <christophe.leroy@c-s.fr>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34926 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752540AbdJQNrr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Oct 2017 09:47:47 -0400
In-Reply-To: <3fc056b8-690c-6cec-3af6-0e6d55f4628c@c-s.fr>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 17. Oktober 2017, 10:51:06 CEST schrieb Christophe LEROY:

Hi Christophe,

> 
> I've now tried a test with 1.0.0, and there seems to be another big
> issue: the error returned by sendmsg() is not taken into account anymore:

It seems that this bug was there before. Can you please check whether this one 
fixes it?

diff --git a/lib/kcapi-kernel-if.c b/lib/kcapi-kernel-if.c
index e00d328..9053104 100644
--- a/lib/kcapi-kernel-if.c
+++ b/lib/kcapi-kernel-if.c
@@ -321,6 +321,8 @@ int32_t _kcapi_common_vmsplice_chunk_fd(struct 
kcapi_handle *handle, int *fdptr,
 
                if ((handle->processed_sg++) > handle->flags.alg_max_pages) {
                        ret = _kcapi_common_send_data(handle, &iov, 1, 
sflags);
+                       if (ret < 0)
+                               return ret;
                } else {
                        ret = vmsplice(handle->pipes[1], &iov, 1,
                                       SPLICE_F_GIFT|flags);

Thanks

Ciao
Stephan
