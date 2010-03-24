From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUGFIX] Fix AES-NI CTR optimization compiling failure with gas
 2.16.1
Date: Wed, 24 Mar 2010 06:51:12 -0400
Message-ID: <20100324065112.823c8d4f.akpm@linux-foundation.org>
References: <1268377307.1640.491.camel@yhuang-dev.sh.intel.com>
	<20100323142324.a53b20de.akpm@linux-foundation.org>
	<1269411858.23970.26.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Huang Ying <ying.huang@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1269411858.23970.26.camel@yhuang-dev.sh.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, 24 Mar 2010 14:24:18 +0800 Huang Ying <ying.huang@intel.com> wrote:

> Can you tell me how to setup the building environment with binutils
> 2.16.1? I just build it by hand and make the installed bin directory the
> first one in $PATH.

gcc searches an internal search patch before $PATH.  They say this can
be overridden with the -B option or the GCC_EXEC_PREFIX environment
var.

For once-off stuff I just get dirty and do `make V=1'.  Then copy and
paste the gcc command line and add `-v'.  Then copy, paste and edit the
various gcc subcommands.
