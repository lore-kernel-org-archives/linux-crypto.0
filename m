From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: dm-crypt IV generation (summary)
Date: Thu, 6 Apr 2017 17:29:57 +0800
Message-ID: <20170406092957.GA31341@gondor.apana.org.au>
References: <CAFqZXNs0=6+PvpGq3weRwCJkUOfSn06i_fD6ZuvXo_0rms9zeA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Binoy Jayan <binoy.jayan@linaro.org>, Mike Snitzer <snitzer@redhat.com>,
	Gilad Ben-Yossef <gilad@benyossef.com>, dm-devel@redhat.com,
	Mikulas Patocka <mpatocka@redhat.com>,
	linux-crypto@vger.kernel.org, Milan Broz <gmazyland@gmail.com>,
	Alasdair Kergon <agk@redhat.com>
To: Ondrej Mosnacek <omosnace@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAFqZXNs0=6+PvpGq3weRwCJkUOfSn06i_fD6ZuvXo_0rms9zeA@mail.gmail.com>
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

On Fri, Mar 10, 2017 at 02:44:26PM +0100, Ondrej Mosnacek wrote:
> Hi all,
> 
> I was tasked to post a summary the whole dm-crypt IV generation
> problem and all the suggested solutions along with their drawbacks, so
> here it goes...

Thanks for the summary.  It looks good to me.

Something else to keep mind is the potential to reuse IV generators.

Recently a patch has been proposed for fscrypt that also makes
use of essiv (search for "fscrypt: Add support for AES-128-CBC").
It would be great if we could reuse the same code for both dm-crypt
and fscrypt.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
