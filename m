From: Jagan Teki <jagannadh.teki@gmail.com>
Subject: Verify ARM64/Crypto from user space
Date: Tue, 21 Apr 2015 15:42:13 +0530
Message-ID: <CAD6G_RQmu3t1F6hSA8o3kd19Wxh9_HxPSU+sr1Ggp91pG0LwFw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:34895 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbbDUKMP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 Apr 2015 06:12:15 -0400
Received: by lbbuc2 with SMTP id uc2so151731415lbb.2
        for <linux-crypto@vger.kernel.org>; Tue, 21 Apr 2015 03:12:14 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert/David,

I believe for accessing crypto from user-space irrespective underlying kernel
crypto - AF_ALG is one of the best method.

Can you tell me how can we verify the ARM64/Crypto with this(simple
test method with example)
and please provide me any other methods to verify the same from user space.

thanks!
-- 
Jagan.
