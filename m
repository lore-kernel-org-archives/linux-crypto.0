Return-Path: <SRS0=qXKu=AK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CF75C433DF
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jun 2020 21:31:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5464320781
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jun 2020 21:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593466308;
	bh=lJG5ZO1f+HcOWTF3Fmo4H94YFIp+LKXgJGhgVEceGZY=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=0mB2JwMSxgfNwiOIBCy/wfZC/jMRY0yP4QtTohjHTN20x1h7H03+6k484/YX2A7YV
	 +dlRyrlBTBaHVYmAu76yY5pz2klPEMCLmyLL2V88VDrY4I6ks/Utqijn1qoIEHeiWa
	 LD7oI+vo65P9HpEnL2LAmLkPjcC4Y+YfpzFcJYBI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728759AbgF2Vbr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Jun 2020 17:31:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:60644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728764AbgF2SlM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Jun 2020 14:41:12 -0400
Received: from localhost.localdomain (82-64-249-211.subs.proxad.net [82.64.249.211])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80E2423158;
        Mon, 29 Jun 2020 07:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593416381;
        bh=lJG5ZO1f+HcOWTF3Fmo4H94YFIp+LKXgJGhgVEceGZY=;
        h=From:To:Cc:Subject:Date:From;
        b=hk5EfjvSf4JQVsoSRW/cmTTTcuDatjtDOMkQ97QiXd7cPBprPuynHU+r+VKbjsP7m
         KDFWJJdSlkaT9MvagEM3lB3LmG4pD+3WOymJrdRtyoTUX0K+dSVBeIgatFp3iLa48M
         /zGKAR0CzewHOhzjIMixhirH03YsjglxG+W3HP90=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 0/5] crypto: clean up ARM/arm64 glue code for GHASH and GCM
Date:   Mon, 29 Jun 2020 09:39:20 +0200
Message-Id: <20200629073925.127538-1-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Get rid of pointless indirect calls where the target of the call is decided
at boot and never changes. Also, make the size of the key struct variable,
and only carry the extra keys needed for aggregation when using a version
of the algorithm that makes use of them.

Ard Biesheuvel (5):
  crypto: arm64/ghash - drop PMULL based shash
  crypto: arm64/gcm - disentangle ghash and gcm setkey() routines
  crypto: arm64/gcm - use variably sized key struct
  crypto: arm64/gcm - use inline helper to suppress indirect calls
  crypto: arm/ghash - use variably sized key struct

 arch/arm/crypto/ghash-ce-glue.c   |  51 ++--
 arch/arm64/crypto/ghash-ce-glue.c | 257 +++++++-------------
 2 files changed, 118 insertions(+), 190 deletions(-)

-- 
2.20.1

