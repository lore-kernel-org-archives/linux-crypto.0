From: Stephan Mueller <smueller@chronox.de>
Subject: SPHINX: no structured comments
Date: Sat, 15 Oct 2016 17:05:51 +0200
Message-ID: <1730886.FCUxIFiraa@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: linux-doc@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:52878 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754672AbcJOPHs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 15 Oct 2016 11:07:48 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

I am converting the kernel crypto API DocBook into Sphinx. The conversion is 
complete, but I am having difficulties finding the cause for the following 
notification obtained during the Sphinx compilation:

./include/linux/crypto.h:1: warning: no structured comments found

I am unsure what is wrong in line 1 of the mentioned header.

Thanks a lot
Stephan
