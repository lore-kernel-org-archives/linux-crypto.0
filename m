From: Harsh Jain <harshjain.prof@gmail.com>
Subject: rmmod crypto driver when ipsec is in use
Date: Thu, 8 Sep 2016 15:17:46 +0530
Message-ID: <CAFXBA==cKF9DgBtMSEK42D-ukw4VX6NRVXgCAbiLf-XqMUAGOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:33320 "EHLO
        mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965818AbcIHJrs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Sep 2016 05:47:48 -0400
Received: by mail-oi0-f49.google.com with SMTP id y2so63480869oie.0
        for <linux-crypto@vger.kernel.org>; Thu, 08 Sep 2016 02:47:48 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

What is the expected behavior when driver is unregistered(Rmmod ) with
active ipsec session.?
I am getting stacktrace(BUG_ON in crypto_unregister_alg) instead of
"module in use".


Regards
Harsh Jain
