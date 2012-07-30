From: Michael Ellerman <michael@ellerman.id.au>
Subject: Re: [PATCH 3/4] powerpc/crypto: add 842 hardware compression driver
Date: Mon, 30 Jul 2012 18:00:59 +1000
Message-ID: <1343635259.10666.1.camel@concordia>
References: <1342708961-28587-1-git-send-email-sjenning@linux.vnet.ibm.com>
	 <1342708961-28587-4-git-send-email-sjenning@linux.vnet.ibm.com>
	 <1342762410.15356.7.camel@concordia> <500964A7.1020702@linux.vnet.ibm.com>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <500964A7.1020702@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, 2012-07-20 at 09:01 -0500, Seth Jennings wrote:
> On 07/20/2012 12:33 AM, Michael Ellerman wrote:
> > On Thu, 2012-07-19 at 09:42 -0500, Seth Jennings wrote:
> >> This patch adds the driver for interacting with the 842
> >> compression accelerator on IBM Power7+ systems.
> > 
> > ...
> > 
> >> +struct nx842_slentry {
> >> +	unsigned long ptr; /* Absolute address (use virt_to_abs()) */
> >> /+	unsigned long len;
> >> +};
> > 
> > These days virt_to_abs() is just __pa() - ie. convert to a real address.
> 
> Thanks, I'll make that change.
> 
> Is it a blocker to the code being pulled in though? I'm
> hoping to get this in ASAP for the 3.6 merge window.  As
> this isn't a functional defect (I assume __pa() and
> virt_to_abs() still achieve the same result), can I get an
> OK from you that this isn't a blocker to the code being
> accepted?

Sorry I missed your reply. No it's not a blocker, just ugly.

I have sent a series to Ben which removes virt_to_abs() entirely, so
we'll want to make sure we fixup the nx driver before that goes in.

cheers
