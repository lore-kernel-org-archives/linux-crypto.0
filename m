From: Tejun Heo <tj@kernel.org>
Subject: Re: workqueue list corruption
Date: Mon, 5 Jun 2017 15:42:36 -0400
Message-ID: <20170605194236.GB9399@htj.duckdns.org>
References: <CAM_iQpXw5ogr3zPOuvupWDjApSeOXWmuSSZzpnK4UApUZC5VVg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Samuel Holland <samuel@sholland.org>, jiangshanlai@gmail.com,
        jason@zx2c4.com, LKML <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>
To: Cong Wang <xiyou.wangcong@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAM_iQpXw5ogr3zPOuvupWDjApSeOXWmuSSZzpnK4UApUZC5VVg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello,

On Sun, Jun 04, 2017 at 12:30:03PM -0700, Cong Wang wrote:
> On Tue, Apr 18, 2017 at 8:08 PM, Samuel Holland <samuel@sholland.org> wrote:
> > Representative backtraces follow (the warnings come in sets). I have
> > kernel .configs and extended netconsole output from several occurrences
> > available upon request.
> >
> > WARNING: CPU: 1 PID: 0 at lib/list_debug.c:33 __list_add+0x89/0xb0
> > list_add corruption. prev->next should be next (ffff99f135016a90), but
> > was ffffd34affc03b10. (prev=ffffd34affc03b10).

So, while trying to move a work item from delayed list to the pending
list, the pending list's last item's next pointer is no longer
pointing to the head and looks re-initialized.  Could be a premature
free and reuse.

If this is reproducible, it'd help a lot to update move_linked_works()
to check for list validity directly and print out the work function of
the corrupt work item.  There's no guarantee that the re-user is the
one which did premature free but given that we're likely seeing
INIT_LIST_HEAD() instead of random corruption is encouraging, so
there's some chance that doing that would point us to the culprit or
at least pretty close to it.

Thanks.

-- 
tejun
