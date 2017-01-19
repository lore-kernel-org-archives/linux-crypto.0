From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [RFC PATCH v3] crypto: Add IV generation algorithms
Date: Thu, 19 Jan 2017 11:47:33 +0200
Message-ID: <CAOtvUMenhgAuZXcsUPpOd5RfQh8XE9krve5YsFF3h-gK8KfDYQ@mail.gmail.com>
References: <1484732425-10319-1-git-send-email-binoy.jayan@linaro.org>
	<1484732425-10319-2-git-send-email-binoy.jayan@linaro.org>
	<CAOtvUMfhethgZ8TarKGDumL1W5fgjwy1Hi7f88mmCCD6vJ_hLg@mail.gmail.com>
	<CAHv-k_-7m_oiVgzB5a3_=R9+fouxUc6fyxSchGtxfUKP00eM4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Rajendra <rnayak@codeaurora.org>, Herbert Xu <herbert@gondor.apana.org.au>,
        Oded <oded.golombek@arm.com>, Mike Snitzer <snitzer@redhat.com>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Milan Broz <gmazyland@gmail.com>, linux-raid@vger.kernel.org,
        dm-devel@redhat.com, Mark Brown <broonie@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
        Shaohua Li <shli@kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Alasdair Kergon <agk@redhat.com>, Ofir <Ofir.Drang@arm.com>
To: Binoy Jayan <binoy.jayan@linaro.org>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAHv-k_-7m_oiVgzB5a3_=R9+fouxUc6fyxSchGtxfUKP00eM4w@mail.gmail.com>
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

On Thu, Jan 19, 2017 at 6:42 AM, Binoy Jayan <binoy.jayan@linaro.org> wrote:
> Hi Gilad,
>
> On 18 January 2017 at 20:51, Gilad Ben-Yossef <gilad@benyossef.com> wrote:
>> I have some review comments and a bug report -
>
> Thank you very much for testing this on ARM and for the comments.

My pleasure. Thanks for writing the code :-)

>
>>> +       rinfo.iv_sector = ctx->cc_sector;
>>> +       rinfo.nents = nents;
>>> +       rinfo.iv = iv;
>>> +
>>> +       skcipher_request_set_crypt(req, dmreq->sg_in, dmreq->sg_out,
>>
>> Also, where do the scatterlist src2 and dst2 that you use
>> sg_set_page() get sg_init_table() called on?
>> I couldn't figure it out...
>
> Thank you pointing this out. I missed out to add sg_init_table(src2, 1)
> and sg_init_table(dst2, 1), but sg_set_page is used in geniv_iter_block.
> This is probably the reason for the panic on ARM platform. However it
> ran fine under qemu-x86. May be I should setup an arm platform too
> for testing.

I tried adding sg_init_table() where I thought it was appropriate and
it didn't resolve the issue.

For what it's worth, my guess is that the difference between our
setups is not related to Arm but to other options or the storage I'm
using.

Are you using cryptd?

Thanks,
Gilad

>
> Regards,
> Binoy



-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
