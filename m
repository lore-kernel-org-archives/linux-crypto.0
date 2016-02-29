From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] PKCS#7: fix unitialized boolean 'want'
Date: Mon, 29 Feb 2016 14:29:20 +0000
Message-ID: <6132.1456756160@warthog.procyon.org.uk>
References: <1456577126-5351-1-git-send-email-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	James Morris <james.l.morris@oracle.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	Peter Jones <pjones@redhat.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43053 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbcB2O3X (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 29 Feb 2016 09:29:23 -0500
In-Reply-To: <1456577126-5351-1-git-send-email-colin.king@canonical.com>
Content-ID: <6131.1456756160.1@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Colin King <colin.king@canonical.com> wrote:

> The boolean want is not initialized and hence garbage. The default should
> be false (later it is only set to true on tne sinfo->authattrs check).
> 
> Found with static analysis using CoverityScan
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied.
