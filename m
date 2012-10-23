From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: Re: [PATCH 2/2] crypto: camellia - add AES-NI/AVX/x86_64 assembler
 implementation of camellia cipher
Date: Tue, 23 Oct 2012 21:02:10 +0300
Message-ID: <20121023210210.136976q68580l7wo@www.dalek.fi>
References: <20121023175755.5552.23566.stgit@localhost6.localdomain6>
 <20121023175800.5552.47165.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:59097 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756702Ab2JWSCM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Oct 2012 14:02:12 -0400
In-Reply-To: <20121023175800.5552.47165.stgit@localhost6.localdomain6>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Please ignore this patchset, it's missing one important patch.

-Jussi

Quoting Jussi Kivilinna <jussi.kivilinna@mbnet.fi>:

> This patch adds AES-NI/AVX/x86_64 assembler implementation of Camellia block
> cipher. Implementation process data in sixteen block chunks, which are
> byte-sliced and AES SubBytes is reused for Camellia s-box with help of pre-
> and post-filtering.
