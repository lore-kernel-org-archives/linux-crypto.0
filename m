From: Stephan Mueller <smueller@chronox.de>
Subject: algif_akcipher
Date: Sun, 04 Sep 2016 16:06:43 +0200
Message-ID: <1708704.H7uTHYKb98@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, keyrings@vger.kernel.org
To: herbert@gondor.apana.org.au, dhowells@redhat.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:37378 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752152AbcIDOQH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 4 Sep 2016 10:16:07 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert, David,

may I inquire for the plans with algif_akcipher? The reason I am asking is 
whether this interface may be accepted or whether a key rings based solution 
is used and whether I can leave or remove the akcipher related API from my 
libkcapi.

Thanks a lot
Stephan
