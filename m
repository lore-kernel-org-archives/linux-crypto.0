From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [Outreachy kernel] Re: [PATCH] Staging: ccree: Don't use volatile
 for monitor_lock
Date: Mon, 11 Sep 2017 18:11:46 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1709111809180.13726@hadrien>
References: <1505145571-11248-1-git-send-email-srishtishar@gmail.com> <20170911160449.GA11886@kroah.com> <CAB3L5oxcyhgyy8EuGuPo9QtJQd-W7JTgQQE1PfopZFmSx58P9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        outreachy-kernel@googlegroups.com
To: Srishti Sharma <srishtishar@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAB3L5oxcyhgyy8EuGuPo9QtJQd-W7JTgQQE1PfopZFmSx58P9g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On Mon, 11 Sep 2017, Srishti Sharma wrote:

> On Mon, Sep 11, 2017 at 9:34 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Mon, Sep 11, 2017 at 09:29:31PM +0530, Srishti Sharma wrote:
> >> The use of volatile for the variable monitor_lock is unnecessary.
> >>
> >> Signed-off-by: Srishti Sharma <srishtishar@gmail.com>
> >> ---
> >>  drivers/staging/ccree/ssi_request_mgr.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
> >> index e5c2f92..7d77941 100644
> >> --- a/drivers/staging/ccree/ssi_request_mgr.c
> >> +++ b/drivers/staging/ccree/ssi_request_mgr.c
> >> @@ -49,7 +49,7 @@ struct ssi_request_mgr_handle {
> >>       dma_addr_t dummy_comp_buff_dma;
> >>       struct cc_hw_desc monitor_desc;
> >>
> >> -     volatile unsigned long monitor_lock;
> >> +     unsigned long monitor_lock;
> >
> > While volatile is not right, odds are, this is still totally wrong as
> > well.  How about using a "real" lock instead?
>
> I tried to find where is this variable being used in the code, but I
> didn't find any usage of it . It might be an important attribute of
> this structure definition but, I don't see it's value being set to
> anything or being used somewhere .

Try removing it and see if the code still compiles.  There is always a
danger that a use of something could be constructed using ## in a macro,
although given the uses of ## for this driver, it doesn't seem likely
here.

julia
