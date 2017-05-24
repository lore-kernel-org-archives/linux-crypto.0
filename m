From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH v2 10/11] crypto: KEYS: check err on akcipher maxsize
Date: Wed, 24 May 2017 13:49:29 +0100
Message-ID: <21523.1495630169@warthog.procyon.org.uk>
References: <1495033238-26016-11-git-send-email-tudor.ambarus@microchip.com> <1495033238-26016-1-git-send-email-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        keyrings@vger.kernel.org, Nicolas.Ferre@microchip.com
To: Tudor Ambarus <tudor.ambarus@microchip.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47338 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1764204AbdEXMtc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 May 2017 08:49:32 -0400
In-Reply-To: <1495033238-26016-11-git-send-email-tudor.ambarus@microchip.com>
Content-ID: <21522.1495630169.1@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Tudor Ambarus <tudor.ambarus@microchip.com> wrote:

> crypto_akcipher_maxsize() returns minimum length for output buffer
> or error code if key hasn't been set.
> 
> Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>

Reviewed-by: David Howells <dhowells@redhat.com>
