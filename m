From: Arun Murthy <arunrmurthy.83@gmail.com>
Subject: GMAC and CMAC mode
Date: Wed, 3 Oct 2012 10:25:40 +0530
Message-ID: <CAAnUQp0Q0MBvnJRhxStvs=BRJKw9ZXqAmiWeme7--+223_C+RA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Arun Murthy <arun.murthy@stericsson.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49568 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755336Ab2JCEzl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Oct 2012 00:55:41 -0400
Received: by eekb15 with SMTP id b15so3632504eek.19
        for <linux-crypto@vger.kernel.org>; Tue, 02 Oct 2012 21:55:40 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi All,

I see that there is no specific core driver or framework for GMAC and CMAC mode.
My hardware accelerator has support for GMAC and CMAC modes, how to I
proceed with writing a driver for the same?

Thanks and Regards,
Arun R Murthy
---------------------
