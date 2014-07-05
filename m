From: Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH] Potential NULL pointer deference in drbg_ctr_df
Date: Sat, 5 Jul 2014 08:36:07 +0800
Message-ID: <20140705003607.GA30874@localhost>
References: <20140620202418.GZ5015@mwanda>
 <20140625090646.GB8727@gondor.apana.org.au>
 <20140704105003.GA25934@mwanda>
 <3313472.TGNVD1jVhQ@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, kbuild@01.org,
 Herbert Xu <herbert@gondor.apana.org.au>, linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <kbuild-bounces@lists.01.org>
Content-Disposition: inline
In-Reply-To: <3313472.TGNVD1jVhQ@myon.chronox.de>
List-Unsubscribe: <https://lists.01.org/mailman/options/kbuild>,
 <mailto:kbuild-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/kbuild/>
List-Post: <mailto:kbuild@lists.01.org>
List-Help: <mailto:kbuild-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/kbuild>,
 <mailto:kbuild-request@lists.01.org?subject=subscribe>
Errors-To: kbuild-bounces@lists.01.org
Sender: "kbuild" <kbuild-bounces@lists.01.org>
List-Id: linux-crypto.vger.kernel.org

On Sat, Jul 05, 2014 at 02:00:15AM +0200, Stephan Mueller wrote:
> Am Freitag, 4. Juli 2014, 13:50:03 schrieb Dan Carpenter:
> 
> Hi Dan,
> 
> > On Wed, Jun 25, 2014 at 05:06:46PM +0800, Herbert Xu wrote:
> > > On Sat, Jun 21, 2014 at 02:26:29PM +0200, Stephan Mueller wrote:
> > > > The handling of additional input data / personalization string data may
> > > > be subject to a NULL pointer deference for the CTR DRBG. The
> > > > caller-provided data may be NULL which must be caught by the DRBG.
> > > > 
> > > > Reported-by: kbuild test robot <fengguang.wu@intel.com>
> > 
> > Oh, huh.  This bug was actually reported by me but I forgot to change
> > the from header and apparently my smtp server allows me to send emails
> > as if I work for Intel.  :P
> > 
> > Fengguang is much nicer than I am.  :P
> 
> Too late, your colleague's name is now in the patches ;-)

Thank you nice guys! :P

Thanks,
Fengguang
