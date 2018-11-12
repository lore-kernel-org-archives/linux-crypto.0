Return-Path: <SRS0=oFif=NX=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46326 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729266AbeKLWZF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Nov 2018 17:25:05 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20181112102423.30415-5-roberto.sassu@huawei.com>
References: <20181112102423.30415-5-roberto.sassu@huawei.com> <20181112102423.30415-1-roberto.sassu@huawei.com>
To: Roberto Sassu <roberto.sassu@huawei.com>
Cc: dhowells@redhat.com, dwmw2@infradead.org,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        silviu.vlasceanu@huawei.com
Subject: Re: [RFC][PATCH 04/12] PGPLIB: Basic packet parser
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <19256.1542025917.1@warthog.procyon.org.uk>
Date: Mon, 12 Nov 2018 12:31:57 +0000
Message-ID: <19257.1542025917@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Roberto Sassu <roberto.sassu@huawei.com> wrote:

> +	size_t size, datalen = *_datalen;
> ...
> +	if ((int)size < 0)
> +		goto too_big;

Hmmm...  "if (size > INT_MAX)" is probably better.

David
