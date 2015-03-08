From: sri sowj <srisowj4linux@gmail.com>
Subject: tcrypt.ko module usage
Date: Sun, 8 Mar 2015 14:32:53 +0530
Message-ID: <CAHTT9VK5+AEGv1nbi5des3coux=6cW1Qukr4Zzep0QzYj0XJCQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:38849 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbbCHJCy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 8 Mar 2015 05:02:54 -0400
Received: by pdbfl12 with SMTP id fl12so55991755pdb.5
        for <linux-crypto@vger.kernel.org>; Sun, 08 Mar 2015 01:02:53 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

HI All,


As I understand tcrypt.ko module purpose is to test different crypto
algorithm from the kenrel space. Please can some one help me with
below queries to understand tcrypt use cases.

#1:If one need to test crypto algorithms with under laying crypto
Hardware engine  using tcrypto module ,is there any method or
procedure needs to be followed to hook crypto hardware engine with
tcrypt module?

As per my understanding its very much straight forward,like if i need
to test aes algorithm then it will be some thing like  "insmod
tcrypt.ko mode = 10"

#2: Is there any way to test tcrypt module for some scenarios like
       2.a:concurrency scenario where multiple processes/threads try
to send a request for same algorithm
       2.b:multiple requests with a same tfm object
       2.c:back logged message scenarios like multiple methods will be
sent for processing while crypto engine is serving a request from same
tfm object

#3:Is there any significance with
"CONFIG_CRYPTO_MANAGER_DISABLE_TESTS" Flag? ,Because when I disable
this flags I observed that tcrypt module
fails with a message like "Failed to load transform for cbc(aes): -2"


BR,
Srisowj
