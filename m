Return-Path: <SRS0=gCBe=74=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDFFBC433DF
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Jun 2020 22:14:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6635207D4
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Jun 2020 22:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592259242;
	bh=6MJX5mFFHP7pSikdN6KoDa9yAVew0bZvri+xHD1+b64=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=K8AMxKhwBRX5kZqtyJemyg0c5IkClNOY/NImdl6H3R87EykulHgcC/ciTZKBMenPF
	 v5DX3EgtGwfOD1J6lx9gx9AlU0vrXmnFbS5quBOWGuciTDlro8rQ8FPN4x6XWQ7+pg
	 Zgi+NDp+RmUHqZedp7zrq7zl6322BdidrLFCLIFI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbgFOWOC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Jun 2020 18:14:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:36696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726044AbgFOWOB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Jun 2020 18:14:01 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2610F20739;
        Mon, 15 Jun 2020 22:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592259241;
        bh=6MJX5mFFHP7pSikdN6KoDa9yAVew0bZvri+xHD1+b64=;
        h=From:To:Cc:Subject:Date:From;
        b=IfFpeueXu+3dCu3qUU+qozsvT8FIYzxZcl6tWo15jqhtdMOdreJx5J+oObyDl6wKZ
         q8qHsQdfVGb9h9mbg6J2/N9rKazG2P9F6rPwQiZXJR0GMITCFdmCKxthOIJwHyhC0H
         lBjwjti4uHWuzNQ6OkDTiCKaLbKRcU8c5ieSKeRE=
From:   Eric Biggers <ebiggers@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux-crypto@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH net v5 0/3] esp, ah: improve crypto algorithm selections
Date:   Mon, 15 Jun 2020 15:13:15 -0700
Message-Id: <20200615221318.149558-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.27.0.290.gba653c62da-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This series consolidates and modernizes the lists of crypto algorithms
that are selected by the IPsec kconfig options, and adds CRYPTO_SEQIV
since it no longer gets selected automatically by other things.

See previous discussion at
https://lkml.kernel.org/netdev/20200604192322.22142-1-ebiggers@kernel.org/T/#u

Changed v4 => v5:
  - Rebased onto latest net/master to resolve conflict with
    "treewide: replace '---help---' in Kconfig files with 'help'"

Changed v3 => v4:
  - Don't say that AH is "NOT RECOMMENDED" by RFC 8221.
  - Updated commit messages (added Acked-by tags, fixed a bad Fixes tag,
    added some more explanation to patch 3).

Eric Biggers (3):
  esp, ah: consolidate the crypto algorithm selections
  esp: select CRYPTO_SEQIV
  esp, ah: modernize the crypto algorithm selections

 net/ipv4/Kconfig | 34 ++++++++++++++++++----------------
 net/ipv6/Kconfig | 34 ++++++++++++++++++----------------
 net/xfrm/Kconfig | 24 ++++++++++++++++++++++++
 3 files changed, 60 insertions(+), 32 deletions(-)

-- 
2.27.0.290.gba653c62da-goog

