From: Michael Ellerman <michael@ellerman.id.au>
Subject: Re: [PATCH 3/4] powerpc/crypto: add 842 hardware compression driver
Date: Fri, 20 Jul 2012 15:33:30 +1000
Message-ID: <1342762410.15356.7.camel@concordia>
References: <1342708961-28587-1-git-send-email-sjenning@linux.vnet.ibm.com>
	 <1342708961-28587-4-git-send-email-sjenning@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Kent Yoder <key@linux.vnet.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
	Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Robert Jennings <rcj@linux.vnet.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:60652 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412Ab2GTFd3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 20 Jul 2012 01:33:29 -0400
In-Reply-To: <1342708961-28587-4-git-send-email-sjenning@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 2012-07-19 at 09:42 -0500, Seth Jennings wrote:
> This patch adds the driver for interacting with the 842
> compression accelerator on IBM Power7+ systems.

...

> +struct nx842_slentry {
> +	unsigned long ptr; /* Absolute address (use virt_to_abs()) */
> /+	unsigned long len;
> +};

These days virt_to_abs() is just __pa() - ie. convert to a real address.

So you should just use __pa().

And you also need to be certain that you only call it on addresses where
that makes sense, ie. not vmalloc etc.

cheers
