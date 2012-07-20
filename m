From: Seth Jennings <sjenning@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/4] powerpc/crypto: add 842 hardware compression driver
Date: Fri, 20 Jul 2012 09:01:11 -0500
Message-ID: <500964A7.1020702@linux.vnet.ibm.com>
References: <1342708961-28587-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <1342708961-28587-4-git-send-email-sjenning@linux.vnet.ibm.com>
 <1342762410.15356.7.camel@concordia>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Robert Jennings <rcj@linux.vnet.ibm.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, linux-kernel@vger.kernel.org,
 Paul Mackerras <paulus@samba.org>, Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Andrew Morton <akpm@linux-foundation.org>, Kent Yoder <key@linux.vnet.ibm.com>,
 linuxppc-dev@lists.ozlabs.org, "David S. Miller" <davem@davemloft.net>,
 linux-crypto@vger.kernel.org
To: Michael Ellerman <michael@ellerman.id.au>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <1342762410.15356.7.camel@concordia>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
List-Id: linux-crypto.vger.kernel.org

On 07/20/2012 12:33 AM, Michael Ellerman wrote:
> On Thu, 2012-07-19 at 09:42 -0500, Seth Jennings wrote:
>> This patch adds the driver for interacting with the 842
>> compression accelerator on IBM Power7+ systems.
> 
> ...
> 
>> +struct nx842_slentry {
>> +	unsigned long ptr; /* Absolute address (use virt_to_abs()) */
>> /+	unsigned long len;
>> +};
> 
> These days virt_to_abs() is just __pa() - ie. convert to a real address.

Thanks, I'll make that change.

Is it a blocker to the code being pulled in though? I'm
hoping to get this in ASAP for the 3.6 merge window.  As
this isn't a functional defect (I assume __pa() and
virt_to_abs() still achieve the same result), can I get an
OK from you that this isn't a blocker to the code being
accepted?

I'll submit a patch later to make this change.

Thanks again!

Seth
