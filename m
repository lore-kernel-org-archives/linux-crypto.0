Return-Path: <SRS0=1oRy=R4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69A1AC43381
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Mar 2019 21:27:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46D9820848
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Mar 2019 21:27:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730354AbfCYV07 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Mar 2019 17:26:59 -0400
Received: from smtprelay0211.hostedemail.com ([216.40.44.211]:53880 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729693AbfCYV06 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Mar 2019 17:26:58 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id DF00718224D82;
        Mon, 25 Mar 2019 21:26:56 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: hat83_1f612ca211116
X-Filterd-Recvd-Size: 3218
Received: from joe-laptop.perches.com (unknown [47.151.153.53])
        (Authenticated sender: joe@perches.com)
        by omf02.hostedemail.com (Postfix) with ESMTPA;
        Mon, 25 Mar 2019 21:26:55 +0000 (UTC)
From:   Joe Perches <joe@perches.com>
To:     linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?Breno=20Leit=C3=A3o?= <leitao@debian.org>,
        Nayna Jain <nayna@linux.ibm.com>,
        Paulo Flabiano Smorigo <pfsmorigo@gmail.com>,
        linux-crypto@vger.kernel.org, Dan Streetman <ddstreet@ieee.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Bad file pattern in MAINTAINERS section 'IBM Power in-Nest Crypto Acceleration'
Date:   Mon, 25 Mar 2019 14:26:54 -0700
Message-Id: <20190325212654.26627-1-joe@perches.com>
X-Mailer: git-send-email 2.15.0
In-Reply-To: <7cd8d12f59bcacd18a78f599b46dac555f7f16c0.camel@perches.com>
References: <7cd8d12f59bcacd18a78f599b46dac555f7f16c0.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

A file pattern line in this section of the MAINTAINERS file in linux-next
does not have a match in the linux source files.

This could occur because a matching filename was never added, was deleted
or renamed in some other commit.

The commits that added and if found renamed or removed the file pattern
are shown below.

Please fix this defect appropriately.

1: ---------------------------------------------------------------------------

linux-next MAINTAINERS section:

	7370	IBM Power in-Nest Crypto Acceleration
	7371	M:	Breno Leitão <leitao@debian.org>
	7372	M:	Nayna Jain <nayna@linux.ibm.com>
	7373	M:	Paulo Flabiano Smorigo <pfsmorigo@gmail.com>
	7374	L:	linux-crypto@vger.kernel.org
	7375	S:	Supported
	7376	F:	drivers/crypto/nx/Makefile
	7377	F:	drivers/crypto/nx/Kconfig
	7378	F:	drivers/crypto/nx/nx-aes*
	7379	F:	drivers/crypto/nx/nx-sha*
	7380	F:	drivers/crypto/nx/nx.*
	7381	F:	drivers/crypto/nx/nx_csbcpb.h
-->	7382	F:	drivers/crypto/nx/nx_debugfs.h

2: ---------------------------------------------------------------------------

The most recent commit that added or modified file pattern 'drivers/crypto/nx/nx_debugfs.h':

commit 28bceeaaf81140d69647acd0eb7dc9312f27844a
Author: Dan Streetman <ddstreet@ieee.org>
Date:   Thu Jun 18 12:28:32 2015 -0400

    MAINTAINERS: clarify drivers/crypto/nx/ file ownership
    
    Update the "IBM Power in-Nest Crypto Acceleration" and
    "IBM Power 842 compression accelerator" sections to specify the correct
    files.
    
    The "IBM Power in-Nest Crypto Acceleration" was originally the only
    NX driver, and so its section listed all drivers/crypto/nx/ files,
    but now there is also the 842 driver which has its own section.  This
    lists explicitly what files are owned by the Crypto driver and which
    files are owned by the 842 compression driver.
    
    Signed-off-by: Dan Streetman <ddstreet@ieee.org>
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

 MAINTAINERS | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

3: ---------------------------------------------------------------------------

No commit with file pattern 'drivers/crypto/nx/nx_debugfs.h' was found
