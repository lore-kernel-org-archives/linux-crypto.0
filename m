From: Alex Cope <alexcope@google.com>
Subject: [RFC][PATCH 0/7] crypto: Adding Hash-Encrypt-Hash(HEH)
Date: Mon, 14 Nov 2016 13:01:11 -0800
Message-ID: <1479157277-10251-1-git-send-email-alexcope@google.com>
Cc: mhalcrow@google.com, edknapp@google.com,
        Alex Cope <alexcope@google.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f47.google.com ([74.125.83.47]:36665 "EHLO
        mail-pg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753274AbcKNVBj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Nov 2016 16:01:39 -0500
Received: by mail-pg0-f47.google.com with SMTP id f188so57851582pgc.3
        for <linux-crypto@vger.kernel.org>; Mon, 14 Nov 2016 13:01:39 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patchset implements HEH, which is currently specified by the
following Internet Draft: 
	
	https://tools.ietf.org/html/draft-cope-heh-00

This patchset is a request for comments, and should not be merged at 
this time. We would like to wait for further comments on the Internet
Draft before merging this patchset.

Thanks
