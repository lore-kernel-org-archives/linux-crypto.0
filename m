From: Harsh Jain <harshjain.prof@gmail.com>
Subject: BUG: Seems un-initialed dst pointer received from algif_aead when
 outlen is zero
Date: Tue, 21 Mar 2017 11:43:53 +0530
Message-ID: <CAFXBA==w7CK_CiiVC37NN8=7p7=a=18sNd5VTnUkDCozrMvT+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:35132 "EHLO
        mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751668AbdCUGNy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Mar 2017 02:13:54 -0400
Received: by mail-qk0-f174.google.com with SMTP id v127so127870328qkb.2
        for <linux-crypto@vger.kernel.org>; Mon, 20 Mar 2017 23:13:53 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

For tag only AEAD decrypt operation(Zero length Payload). The dst sg
list pointer panic with general protection fault. I think it should be
NULL when output buffer is supposed to be empty.

Kcapi command to re-produce the issue

./kcapi -x 2   -c "gcm(aes)" -i 0d92aa861746b324f20ee6b7 -k
f4a6a5e5f2066f6dd9ec6fc5169c29043560ef595c9e81e76f42d29212cc581c -a ""
-t "5f24c68cbe6f32c29652442bf5d483ad" -q ""

Its decrypt operation. Expected result should be EBADMSG.


Regards
Harsh Jain
