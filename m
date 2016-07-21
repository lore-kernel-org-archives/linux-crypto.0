From: Harsh Jain <harshjain.prof@gmail.com>
Subject: Max data limit for AEAD operation
Date: Thu, 21 Jul 2016 17:42:56 +0530
Message-ID: <CAFXBA==j+6fGuWrjNroGWnnBc13ev+6EB2Ae7SnwAVVxjTWBrw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:33183 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068AbcGUMM6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 Jul 2016 08:12:58 -0400
Received: by mail-oi0-f48.google.com with SMTP id j185so114354841oih.0
        for <linux-crypto@vger.kernel.org>; Thu, 21 Jul 2016 05:12:58 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi All,

There is maximum limit of data which crypto user can send(in encrypt)
to get TAG in AEAD operations. We do not have update/final like
implementation for AEAD algo's. why is this so?


Regards
Harsh Jain
