From: Binoy Jayan <binoy.jayan@linaro.org>
Subject: Re: [RFC PATCH v3] crypto: Add IV generation algorithms
Date: Thu, 19 Jan 2017 10:12:23 +0530
Message-ID: <CAHv-k_-7m_oiVgzB5a3_=R9+fouxUc6fyxSchGtxfUKP00eM4w@mail.gmail.com>
References: <1484732425-10319-1-git-send-email-binoy.jayan@linaro.org>
 <1484732425-10319-2-git-send-email-binoy.jayan@linaro.org> <CAOtvUMfhethgZ8TarKGDumL1W5fgjwy1Hi7f88mmCCD6vJ_hLg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Oded <oded.golombek@arm.com>, Ofir <Ofir.Drang@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org,
        Rajendra <rnayak@codeaurora.org>,
        Milan Broz <gmazyland@gmail.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOtvUMfhethgZ8TarKGDumL1W5fgjwy1Hi7f88mmCCD6vJ_hLg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Gilad,

On 18 January 2017 at 20:51, Gilad Ben-Yossef <gilad@benyossef.com> wrote:
> I have some review comments and a bug report -

Thank you very much for testing this on ARM and for the comments.

> I'm pretty sure this needs to be
>
>  n2 = bio_segments(ctx->bio_out);

Yes you are right, that was a typo :)

>> +
>> +       rinfo.is_write = bio_data_dir(ctx->bio_in) == WRITE;
>
> Please consider wrapping the above boolean expression in parenthesis.

Well, I can do that to enhance the clarity.

>> +       rinfo.iv_sector = ctx->cc_sector;
>> +       rinfo.nents = nents;
>> +       rinfo.iv = iv;
>> +
>> +       skcipher_request_set_crypt(req, dmreq->sg_in, dmreq->sg_out,
>
> Also, where do the scatterlist src2 and dst2 that you use
> sg_set_page() get sg_init_table() called on?
> I couldn't figure it out...

Thank you pointing this out. I missed out to add sg_init_table(src2, 1)
and sg_init_table(dst2, 1), but sg_set_page is used in geniv_iter_block.
This is probably the reason for the panic on ARM platform. However it
ran fine under qemu-x86. May be I should setup an arm platform too
for testing.

Regards,
Binoy
