From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/9] crypto: add zbufsize() interface
Date: Wed, 8 Aug 2018 10:53:19 +0800
Message-ID: <20180808025319.32d57wtjpyyapwo5@gondor.apana.org.au>
References: <20180802215118.17752-1-keescook@chromium.org>
 <20180802215118.17752-2-keescook@chromium.org>
 <20180807094513.vstt5dhbb7n6kvds@gondor.apana.org.au>
 <CAGXu5j+dPqpJZbO_AuGsNqJzq7XGcB2deXA5RELWv1-Ywi5QOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Geliang Tang <geliangtang@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Haren Myneni <haren@us.ibm.com>,
        Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
To: Kees Cook <keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGXu5j+dPqpJZbO_AuGsNqJzq7XGcB2deXA5RELWv1-Ywi5QOA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Aug 07, 2018 at 11:10:10AM -0700, Kees Cook wrote:
>
> > Please don't add new features to the old compress interface.  Any
> > new improvements should be added to scomp/acomp only.  Users who
> > need new features should be converted.
> 
> So, keep crypto_scomp_zbufsize() and drop crypto_comp_zbufsize() and
> crypto_zbufsize()? Should I add crypto_acomp_zbufsize()?

Yes and yes.  acomp is the primary interface and should support
all the features in scomp.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
