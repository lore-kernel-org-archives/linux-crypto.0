From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v2 0/8] crypto: ARM/arm64 - big endian fixes
Date: Wed, 19 Oct 2016 10:15:49 +0100
Message-ID: <20161019091549.GF9193@arm.com>
References: <1476209720-21114-1-git-send-email-ard.biesheuvel@linaro.org>
 <20161018114932.GG10115@e104818-lin.cambridge.arm.com>
 <CAKv+Gu9wuXnrq77a3Zk0GnHgnkpURh=EegwgP+vAwMC=rdm3qA@mail.gmail.com>
 <20161019030333.GA1269@gondor.apana.org.au>
 <20161019084607.GB9193@arm.com>
 <CAKv+Gu_A1XOL=yST_isyvMZL=9wUcuiFXdfmOqw7PO5te24Ktw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Russell King - ARM Linux <linux@arm.linux.org.uk>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
 "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_A1XOL=yST_isyvMZL=9wUcuiFXdfmOqw7PO5te24Ktw@mail.gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Oct 19, 2016 at 09:49:46AM +0100, Ard Biesheuvel wrote:
> On 19 October 2016 at 09:46, Will Deacon <will.deacon@arm.com> wrote:
> > On Wed, Oct 19, 2016 at 11:03:33AM +0800, Herbert Xu wrote:
> >> I was planning merging these for 4.10.  But I'm fine with them
> >> going through the arm tree.  Let me know what you guys want to
> >> do.
> >
> > I assumed you'd take them through crypto, as per usual, so I didn't
> > queue anything in the arm64 tree.
> >
> > Ard -- were you planning to get these in for 4.9?
> >
> 
> These are arguably bug fixes, but I spotted them by accident, they
> weren't reported to me or anything. But it seems strange to add a cc
> stable and then hold off until the next merge window.
> 
> In any case, I don't care deeply either way, as long as they get
> merged in the end. I think it makes sense to keep them together (arm64
> + ARM), so Herbert's tree is a more natural route for them to take. I
> will leave it up to Herbert whether they are sent onward as fixes or
> as part of v4.10

Sounds good to me.

Will
