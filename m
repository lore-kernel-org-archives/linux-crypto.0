From: Phil Sutter <phil@nwl.cc>
Subject: Re: mv_cesa dcache problem since 2.6.37 was: Re: mv_cesa hash
 functions
Date: Mon, 7 May 2012 18:50:14 +0200
Message-ID: <20120507165014.GA30092@orbit.nwl.cc>
References: <20120223183439.GA18545@orbit.nwl.cc> <4FA5AE7A.3000201@gmail.com>
 <20120506122506.GJ26481@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-arm-kernel@lists.infradead.org,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Catalin Marinas <catalin.marinas@arm.com>,
 'Sebastian Andrzej Siewior' <sebastian@breakpoint.cc>,
 linux-crypto@vger.kernel.org, uri@jdland.co.il, Frank <frank@debian-nas.org>,
 Simon Baatz <gmbnomis@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20120506122506.GJ26481@n2100.arm.linux.org.uk>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: linux-arm-kernel-bounces@lists.infradead.org
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

Hi,

On Sun, May 06, 2012 at 01:25:06PM +0100, Russell King - ARM Linux wrote:
> On Sun, May 06, 2012 at 12:49:30AM +0200, Simon Baatz wrote:
> > since there has been no reaction on this, I would like to bring this
> > issue up again (I sadly don't have the expertise to investigate this
> > further...). The issue is not limited to cryptodev, but seems to be
> > either a problem with commit f8b63c1 or a problem in mv_cesa that was
> > uncovered by this commit.
> 
> Can you reproduce it with anything else?
> 
> It could be a problem with the way crypto stuff works - I've never had
> any dealings with that subsystem, so I really can't comment.  If crypto
> uses scatterlists, and walks them with the standard API, and uses
> scatterlists with pages which are already mapped into userspace, then
> I can see how the above commit would make things go wrong.

This is quite exactly what happens. Cryptodev uses get_user_pages to get
the pages belonging to the passed userspace addresses, fills
scatterlists with that information and passes them on to the crypto API.
Mv_cesa.c (at least) then uses the scatterlist mapping iterator to feed
the data chunk by chunk to the crypto engine. Upon completion, cryptodev
simply releases the user pages again by using SetPageDirty() and
page_cache_release(). This has proven unreliable, and the solution I
found was to additionally call flush_dcache_page() before returning the
pages to userspace.

> So, without knowledge of the crypto subsystem, I'm not sure I can help
> sort this out.

What would you recommend for iterating over scatterlists with mapped
pages instead? Since the above commit, neither the mapping iterator API
nor the simple sg_next() seem to be suitable anymore.

Greetings, Phil
