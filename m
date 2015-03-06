From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH v2 1/5] crypto: talitos: Simplify per-channel
 initialization
Date: Thu, 5 Mar 2015 18:06:37 -0600
Message-ID: <20150305180637.e64ed8b57ec79620cbb3ac4b@freescale.com>
References: <1425388897-5434-1-git-send-email-mort@bork.org>
	<1425388897-5434-2-git-send-email-mort@bork.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Scott Wood <scottwood@freescale.com>,
	Kumar Gala <galak@kernel.crashing.org>,
	<linuxppc-dev@lists.ozlabs.org>, <linux-crypto@vger.kernel.org>,
	Horia =?UTF-8?Q?Geant=C4=83?= <horia.geanta@freescale.com>
To: Martin Hicks <mort@bork.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0132.outbound.protection.outlook.com ([207.46.100.132]:12836
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752922AbbCFAL7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Mar 2015 19:11:59 -0500
In-Reply-To: <1425388897-5434-2-git-send-email-mort@bork.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue,  3 Mar 2015 08:21:33 -0500
Martin Hicks <mort@bork.org> wrote:

> There were multiple loops in a row, for each separate step of the
> initialization of the channels.  Simplify to a single loop.
> 
> Signed-off-by: Martin Hicks <mort@bork.org>
> ---

Acked-by: Kim Phillips <kim.phillips@freescale.com>

Kim
