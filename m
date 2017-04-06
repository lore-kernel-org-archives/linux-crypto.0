From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-crypt IV generation (summary)
Date: Thu, 6 Apr 2017 10:37:46 -0400
Message-ID: <20170406143746.GA19500@redhat.com>
References: <CAFqZXNs0=6+PvpGq3weRwCJkUOfSn06i_fD6ZuvXo_0rms9zeA@mail.gmail.com>
	<20170406092957.GA31341@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Binoy Jayan <binoy.jayan@linaro.org>, Ondrej Mosnacek <omosnace@redhat.com>,
	Gilad Ben-Yossef <gilad@benyossef.com>, dm-devel@redhat.com,
	Mikulas Patocka <mpatocka@redhat.com>,
	linux-crypto@vger.kernel.org, Milan Broz <gmazyland@gmail.com>,
	Alasdair Kergon <agk@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170406092957.GA31341@gondor.apana.org.au>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
List-Id: linux-crypto.vger.kernel.org

On Thu, Apr 06 2017 at  5:29am -0400,
Herbert Xu <herbert@gondor.apana.org.au> wrote:

> On Fri, Mar 10, 2017 at 02:44:26PM +0100, Ondrej Mosnacek wrote:
> > Hi all,
> > 
> > I was tasked to post a summary the whole dm-crypt IV generation
> > problem and all the suggested solutions along with their drawbacks, so
> > here it goes...
> 
> Thanks for the summary.  It looks good to me.

There were 4 different solutions presented.  In reading each, option 2
looked the most promising.  BUT it requires a tradeoff/decision to be
made, please see my earlier reply where I asked for your (and/or
Milan's) thoughts:
https://www.spinics.net/lists/linux-crypto/msg24586.html

Thanks,
Mike
