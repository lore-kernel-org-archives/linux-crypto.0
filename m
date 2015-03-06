From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH 2/2] crypto: talitos: Add AES-XTS Support
Date: Thu, 5 Mar 2015 18:16:15 -0600
Message-ID: <20150305181615.493b173d43249548fae29203@freescale.com>
References: <1424451610-5786-1-git-send-email-mort@bork.org>
	<1424451610-5786-3-git-send-email-mort@bork.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Scott Wood <scottwood@freescale.com>,
	Kumar Gala <galak@kernel.crashing.org>,
	<linuxppc-dev@lists.ozlabs.org>, <linux-crypto@vger.kernel.org>
To: Martin Hicks <mort@bork.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bon0147.outbound.protection.outlook.com ([157.56.111.147]:61148
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753844AbbCFAVf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Mar 2015 19:21:35 -0500
In-Reply-To: <1424451610-5786-3-git-send-email-mort@bork.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 20 Feb 2015 12:00:10 -0500
Martin Hicks <mort@bork.org> wrote:

> The newer talitos hardware has support for AES in XTS mode.

Assuming it's the same thing, AES-XCBC gets added with SEC v3.0
h/w.  Assuming hw_supports() doesn't already support this algorithm
combination (technically via the mode bit), this needs to be
reflected in the patch so the driver doesn't think SEC 2.x devices
can do XTS, too.

> +		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> +					DESC_HDR_SEL0_AESU |
> +					DESC_HDR_MODE0_AESU_XTS,

...

>  /* primary execution unit mode (MODE0) and derivatives */
>  #define	DESC_HDR_MODE0_ENCRYPT		cpu_to_be32(0x00100000)
>  #define	DESC_HDR_MODE0_AESU_CBC		cpu_to_be32(0x00200000)
> +#define	DESC_HDR_MODE0_AESU_XTS		cpu_to_be32(0x04200000)

I'd prefer these defines be kept as single bit definitions, and keep
their names from the manual.  An XTS-specific definition can be
composed from them either after this, or manually in the
desc_hdr_template assignment above.

Thanks,

Kim
