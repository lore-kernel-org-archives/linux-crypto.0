From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 1/3] crypto: dh_helper - return unsigned int for dh_data_size()
Date: Tue, 03 Oct 2017 10:06:02 +0100
Message-ID: <22466.1507021562@warthog.procyon.org.uk>
References: <20170929092106.24276-1-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, keyrings@vger.kernel.org
To: Tudor Ambarus <tudor.ambarus@microchip.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51826 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751266AbdJCJGE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Oct 2017 05:06:04 -0400
In-Reply-To: <20170929092106.24276-1-tudor.ambarus@microchip.com>
Content-ID: <22465.1507021562.1@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Tudor Ambarus <tudor.ambarus@microchip.com> wrote:

> -static inline int dh_data_size(const struct dh *p)
> +static inline unsigned int dh_data_size(const struct dh *p)
>  {
>  	return p->key_size + p->p_size + p->g_size;
>  }

If this is a problem, do you need to do range checking?

David
