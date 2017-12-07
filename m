From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: Re: [PATCH RFC 0/4] crypto: engine - Permit to enqueue all async
 requests
Date: Thu, 7 Dec 2017 10:37:05 +0100
Message-ID: <20171207093705.GB21647@Red>
References: <20171129084121.9385-1-clabbe.montjoie@gmail.com>
 <4d58a1fc-8577-3fdb-ae6b-e1fade7c6582@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        Alexandre TORGUE <alexandre.torgue@st.com>,
        "arei.gonglei@huawei.com" <arei.gonglei@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "mst@redhat.com" <mst@redhat.com>,
        Lionel DEBIEVE <lionel.debieve@st.com>,
        Benjamin GAIGNARD <benjamin.gaignard@st.com>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org"
        <virtualization@lists.linux-foundation.org>
To: Fabien DESSENNE <fabien.dessenne@st.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4d58a1fc-8577-3fdb-ae6b-e1fade7c6582@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Dec 06, 2017 at 10:59:47AM +0000, Fabien DESSENNE wrote:
> Hi Corentin,
> 
> 
> I am fine with this proposal: it is generic enough and I have been able 
> to test and run the crypto engine with aead_request without changing any 
> single line of code.
> 
> This is what I need to be able to send the AEAD extension of the 
> stm32-cryp driver (successfully tested with your engine upgrade proposal).
> 
> 
> I have also tested the stm32-hash patch.
> 
> Note that stm32-cryp (new driver applied by Herbert recently 
> [https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git/commit/?id=9e054ec21ef8344345b28603fb272fe999f735db]) 
> would also need to be converted to the new crypto engine API : this is a 
> trivial patch.

Yes, patch for converting it is already done.

> 
> Thank you for your proposal, I hope that this proposal is fine for 
> Herbert too.
> 

Thanks for your test, I hope other maintainer will test it also.

Regards
Corentin Labbe
