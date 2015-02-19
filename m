From: sri sowj <srisowj4linux@gmail.com>
Subject: Intermediate Hash states
Date: Thu, 19 Feb 2015 21:48:30 +0530
Message-ID: <CAHTT9VLHi6m8-NNS_MJ2cabNm2Eng18zs8iGqJudP1ANb-99Ww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:33160 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbbBSQSb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 19 Feb 2015 11:18:31 -0500
Received: by mail-ob0-f172.google.com with SMTP id nt9so16232246obb.3
        for <linux-crypto@vger.kernel.org>; Thu, 19 Feb 2015 08:18:30 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi ,

I am trying to understand Hashing Algorithms implementation in linux kernel .

I am really not sure on how to deal with following scenario.

assume when App1 is in middle of
execution(crypto_ahash_init/update/update...) ,App2 sends a request
may be from another cpu in multi-core system to underlying crypto
driver .
Then essentially input1 has to save its  state(intermediate Hash) and
serves App2 request.

App1 ---------> Linux kernel crypto driver

       crypto_ahash_init(input1);
        crypto_ahash_update(input1);
       ..................
       ..................
        crypto_ahash_update(input1); // multple Hash requests
       ..................
       ..................
    crypto_ahash_final()



App2 ---------> Linux kernel crypto driver

        crypto_ahash_init(input2);
        crypto_ahash_update(input2);


Here in this scenario how to track,save and restore the Hash state for App1 ?

BR,
Srisowj
