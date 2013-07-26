From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 2/2] drivers/crypto/nx: fix limits to sg lists for SHA-2
Date: Sat, 27 Jul 2013 08:31:32 +1000
Message-ID: <1374877892.9200.30.camel@pasglop>
References: <1374858488-24658-1-git-send-email-mhcerri@linux.vnet.ibm.com>
	 <1374858488-24658-3-git-send-email-mhcerri@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Fionnuala Gunter <fin@linux.vnet.ibm.com>,
	Joel Schopp <jschopp@linux.vnet.ibm.com>,
	Joy Latten <jmlatten@linux.vnet.ibm.com>
To: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:56685 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820Ab3GZWbk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 26 Jul 2013 18:31:40 -0400
In-Reply-To: <1374858488-24658-3-git-send-email-mhcerri@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 2013-07-26 at 14:08 -0300, Marcelo Cerri wrote:
> ---
>  drivers/crypto/nx/nx-sha256.c | 108 +++++++++++++++++++++++-----------------
>  drivers/crypto/nx/nx-sha512.c | 113 ++++++++++++++++++++++++------------------
>  2 files changed, 129 insertions(+), 92 deletions(-)

What about the other nx drivers ? They are not affected ?

Cheers,
Ben.
