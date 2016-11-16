From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH] powerpc: crypto/vmx: clean up generated files
Date: Wed, 16 Nov 2016 16:57:23 +0530
Message-ID: <20161116112723.GC4019@naverao1-tp.localdomain>
References: <20161115170549.10538-1-naveen.n.rao@linux.vnet.ibm.com>
 <87oa1fyc7s.fsf@concordia.ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>,
 linuxppc-dev@lists.ozlabs.org, Herbert Xu <herbert@gondor.apana.org.au>,
 Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>,
 linux-crypto@vger.kernel.org
To: Michael Ellerman <mpe@ellerman.id.au>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
Content-Disposition: inline
In-Reply-To: <87oa1fyc7s.fsf@concordia.ellerman.id.au>
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

On 2016/11/16 09:02PM, Michael Ellerman wrote:
> "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com> writes:
> 
> > ..as stray .S files result in build errors, especially when using
> > cross-compilers.
> 
> They should be cleaned on make clean, so adding them to clean-files
> seems correct.
> 
> > More specifically, the generated .S files are endian-specific and will break
> > subsequent builds targeting the other endian architecture.
> 
> But that indicates we're missing an if_changed somewhere, ie. switching
> endian should cause them to be regenerated.
> 
> Also they should be generated into $(obj) not $(src) I think.
> 
> How about this?

Nice!

> 
> diff --git a/drivers/crypto/vmx/Makefile b/drivers/crypto/vmx/Makefile
> index de6e241..52f6ae9 100644
> --- a/drivers/crypto/vmx/Makefile
> +++ b/drivers/crypto/vmx/Makefile
> @@ -10,10 +10,10 @@ endif
>  quiet_cmd_perl = PERL $@
>        cmd_perl = $(PERL) $(<) $(TARGET) > $(@)
> 

Looks like we also need:

targets += aesp8-ppc.S ghashp8-ppc.S

> -$(src)/aesp8-ppc.S: $(src)/aesp8-ppc.pl
> -       $(call cmd,perl)
> +$(obj)/aesp8-ppc.S: $(src)/aesp8-ppc.pl FORCE
> +       $(call if_changed,perl)
>    
> -$(src)/ghashp8-ppc.S: $(src)/ghashp8-ppc.pl
> -       $(call cmd,perl)
> +$(obj)/ghashp8-ppc.S: $(src)/ghashp8-ppc.pl FORCE
> +       $(call if_changed,perl)
> 
>  .PRECIOUS: $(obj)/aesp8-ppc.S $(obj)/ghashp8-ppc.S

I will send a v2 with these changes.

Thanks,
Naveen
