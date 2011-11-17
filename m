From: satpal parmar <systems.satpal@gmail.com>
Subject: authenc_verify_ahash_done and H/W accelerator
Date: Thu, 17 Nov 2011 17:49:30 +0530
Message-ID: <CAGgcXb5zfa4fsyvN9HbU9NAr0d-ikp67N-=e_9cc+ro_c6xLJg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59493 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757024Ab1KQMTc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 17 Nov 2011 07:19:32 -0500
Received: by ywt32 with SMTP id 32so938428ywt.19
        for <linux-crypto@vger.kernel.org>; Thu, 17 Nov 2011 04:19:32 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi all!

I am currently debugging a  drivers for our crypto HW which offload
IPSec (ESP for now) to HW. With SHA driver I am facing a strange
problem. For reasons unknown to me  'authenc_verify_ahash_done' is
failing (http://lxr.linux.no/linux+v2.6.37/crypto/authenc.c). This api
got called from my SHA driver.

File:http://lxr.linux.no/linux+v2.6.37/crypto/authenc.c

224        authsize = crypto_aead_authsize(authenc);
225        cryptlen -= authsize;
226        ihash = ahreq->result + authsize;
227        scatterwalk_map_and_copy(ihash, areq_ctx->sg, areq_ctx->cryptlen,
228                                 authsize, 0);
229
230        err = memcmp(ihash, ahreq->result, authsize) ? -EBADMSG :
0;   ------>> this is giving bad message.

I am trying to understand authenc_verify_ahash_done to debug this
issue. I do not know if authsize is wrong or scatterwalk_map_and_copy
was a failure or struct crypto_async_request *areq received is
corrupted. Since this API is not involved when I use s/w crypto I do
not have any working example to follow. Just wondering if anyone come
across any such problem or issue while developing H/W crypto driver.

I am using Linux 2.6.37 for my development.

Appreciate any suggestion/pointer regarding my problem.

SP
