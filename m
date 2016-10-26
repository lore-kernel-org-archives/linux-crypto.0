From: =?UTF-8?Q?Juan_Pablo_Nari=C3=B1o_Mendoza?= <jnarino@gmail.com>
Subject: AEAD Question
Date: Wed, 26 Oct 2016 18:17:14 +0200
Message-ID: <CAPSqeoJkTQ72cRaFk+sZGdCELUR6zFBbFdQsZE_B4DF=x374Og@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:36464 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754914AbcJZQRT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Oct 2016 12:17:19 -0400
Received: by mail-wm0-f47.google.com with SMTP id b80so232831970wme.1
        for <linux-crypto@vger.kernel.org>; Wed, 26 Oct 2016 09:17:19 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Sorry in advance for making what shall be a basic question for this
list, but I have really ran out of ideas.

Can someone explain me please, how does the memory layout and sg lists
work for the IPSec case, with generated IV case?

As I understand, it is like this (ascii art)

AD | IV Space | Plain Text | Auth Tag
 ^                   ^
 |                    |
asg              sg

But I am having the AD overwritten, and the AUTH tag and encryption is
not correct? Could someone please point me in the right direction?
Thank you again

Regards

Juan
