From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH v2.1 1/7] crypto: GnuPG based MPI lib - source files
 (part 1)
Date: Mon, 17 Oct 2011 09:22:08 -0700
Message-ID: <20111017162208.GA6661@kroah.com>
References: <cover.1318598705.git.dmitry.kasatkin@intel.com>
 <92d93a9fe52e048a21d19732c31d80c9ec44de77.1318598705.git.dmitry.kasatkin@intel.com>
 <alpine.LRH.2.00.1110151125280.24994@tundra.namei.org>
 <CALLzPKZ63vp9W_p1t1JOCui+aLRyN6W0t9O-tJ40xKxBef0QPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: James Morris <jmorris@namei.org>,
	linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	zohar@linux.vnet.ibm.com, dhowells@redhat.com,
	herbert@gondor.hengli.com.au
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALLzPKZ63vp9W_p1t1JOCui+aLRyN6W0t9O-tJ40xKxBef0QPA@mail.gmail.com>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Oct 17, 2011 at 12:11:37PM +0300, Kasatkin, Dmitry wrote:
> >From Kernel Docbook
> 
>     Similar to <function>EXPORT_SYMBOL()</function> except that the
>     symbols exported by <function>EXPORT_SYMBOL_GPL()</function> can
>     only be seen by modules with a
>     <function>MODULE_LICENSE()</function> that specifies a GPL
>     compatible license.  It implies that the function is considered
>     an internal implementation issue, and not really an interface.
> 
> "not really an interface"....
> 
> Should it really be EXPORT_SYMBOL_GPL?

Yes.
