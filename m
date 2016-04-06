From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] PKCS#7: fix missing break on OID_sha224 case
Date: Wed, 06 Apr 2016 13:55:17 +0100
Message-ID: <2764.1459947317@warthog.procyon.org.uk>
References: <1458316291-25705-1-git-send-email-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: dhowells@redhat.com, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	Peter Jones <pjones@redhat.com>, linux-crypto@vger.kernel.org,
	stable@vger.kernel.org, linux-kernel@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47347 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752382AbcDFMzV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 6 Apr 2016 08:55:21 -0400
In-Reply-To: <1458316291-25705-1-git-send-email-colin.king@canonical.com>
Content-ID: <2762.1459947317.1@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> The OID_sha224 case is missing a break and it falls through
> to the -ENOPKG error default.  Since HASH_ALGO_SHA224 seems
> to be supported, this looks like an unintentional missing break.
> 
> Fixes: 07f081fb5057 ("PKCS#7: Add OIDs for sha224, sha284 and sha512 hash algos and use them")
> Cc: <stable@vger.kernel.org> # 4.2+
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Acked-by: David Howells <dhowells@redhat.com>
