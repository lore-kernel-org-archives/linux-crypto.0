From: Harsh Jain <harshjain.prof@gmail.com>
Subject: What should be the algo priority
Date: Tue, 4 Apr 2017 13:23:17 +0530
Message-ID: <CAFXBA=kTywuuZOKw6a7mj+aXtn0YcOYF=jmesuBE2L3zZmojMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qk0-f169.google.com ([209.85.220.169]:34841 "EHLO
        mail-qk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751101AbdDDHxS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Apr 2017 03:53:18 -0400
Received: by mail-qk0-f169.google.com with SMTP id g195so62576506qke.2
        for <linux-crypto@vger.kernel.org>; Tue, 04 Apr 2017 00:53:18 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

Do we have any guidelines documented to decide what should be the
algorithm priority. Specially for authenc implementation.Most of the
drivers have fixed priority for all algos. Problem comes in when we
have cbc(aes), hmac(sha1) and authenc(cbc(aes),hmac(sha1))
implementation in driver. Base authenc driver gets more precedence
because of higher priority(enc->base.cra_priority * 10 +
auth_base->cra_priority;)

What should be the priority of
cbc(aes),
hmac(sha1)
authenc(cbc(aes),hmac(sha1))


Regards
Harsh Jain
