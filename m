From: Jarod Wilson <jarod@redhat.com>
Subject: Re: [PATCH] crypto/testmgr: add xts-aes-256 self-test
Date: Wed, 25 May 2011 16:46:30 -0400
Message-ID: <4DDD6AA6.30800@redhat.com>
References: <1306348377-14494-1-git-send-email-jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12611 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932237Ab1EYUrL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 May 2011 16:47:11 -0400
In-Reply-To: <1306348377-14494-1-git-send-email-jarod@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Jarod Wilson wrote:
> FIPS compliance requires a known-answer self-test for all approved cipher and
> mode combinations, for all valid key sizes. Presently, there are only
> self-tests for xts-aes-128. This adds a 256-bit one, pulled from the same
> reference document, which should satisfy the requirement.

Oh hell. v2 coming in a bit after I verify its actually really still 
functional with the new vector added. I forgot to update 
AES_XTS_ENC_TEST_VECTORS and AES_XTS_DEC_TEST_VECTORS to match, so the 
new vector wasn't being run.

-- 
Jarod Wilson
jarod@redhat.com
