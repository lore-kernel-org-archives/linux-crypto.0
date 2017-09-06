From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [Outreachy kernel] Re: [PATCH] Staging: ccree: ssi_cipher.c:
 Correct spelling mistake.
Date: Wed, 6 Sep 2017 22:39:54 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1709062235350.2984@hadrien>
References: <1504725863-8495-1-git-send-email-srishtishar@gmail.com> <2b8bde9c-6e84-48c5-ab93-76127f314429@googlegroups.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="8323329-1658514752-1504730395=:2984"
Cc: outreachy-kernel <outreachy-kernel@googlegroups.com>,
        gregkh@linuxfoundation.org, gilad@benyossef.com,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
To: Srishti Sharma <srishtishar@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2b8bde9c-6e84-48c5-ab93-76127f314429@googlegroups.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1658514752-1504730395=:2984
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT



On Wed, 6 Sep 2017, Srishti Sharma wrote:

>
>
> On Thursday, September 7, 2017 at 12:54:49 AM UTC+5:30, Srishti Sharma
> wrote:
>       Correct spelling of counter in comment .
>
>       Signed-off-by: Srishti Sharma <srishtishar@gmail.com>
>       ---
>        drivers/staging/ccree/ssi_cipher.c | 2 +-
>        1 file changed, 1 insertion(+), 1 deletion(-)
>
>       diff --git a/drivers/staging/ccree/ssi_cipher.c
>       b/drivers/staging/ccree/ssi_cipher.c
>       index 8d31a93..99232b2 100644
>       --- a/drivers/staging/ccree/ssi_cipher.c
>       +++ b/drivers/staging/ccree/ssi_cipher.c
>       @@ -702,7 +702,7 @@ static int ssi_blkcipher_complete(struct
>       device *dev,
>
>                ssi_buffer_mgr_unmap_blkcipher_request(dev, req_ctx,
>       ivsize, src, dst);
>
>       -        /*Set the inflight couter value to local variable*/
>       +        /*Set the inflight counter value to local variable*/
>                inflight_counter =  ctx_p->drvdata->inflight_counter;
>                /*Decrease the inflight counter*/
>                if (ctx_p->flow_mode == BYPASS &&
>       ctx_p->drvdata->inflight_counter > 0)
>       --
>       2.7.4
>
>
>   Hey,
>
>   Can I say , /* store the value of inflight_counter variable from  driver
> private data context to a local variable */  , to make it more
> comprehensible ? 

I think it could be a bit of overkill.  The "driver private data context"
part can be seen from a quick glance at the code.  Also, it could be good
to bring out the purpose rather than just what the code does.  So "save
inflight_counter in a a local variable" could be better, because it
focuses on the idea of saving some information for later use.  Good job on
figuring out the formatting problem.

julia

>
> Regards,
> Srishti 
>
> --
> You received this message because you are subscribed to the Google Groups
> "outreachy-kernel" group.
> To unsubscribe from this group and stop receiving emails from it, send an
> email to outreachy-kernel+unsubscribe@googlegroups.com.
> To post to this group, send email to outreachy-kernel@googlegroups.com.
> To view this discussion on the web visithttps://groups.google.com/d/msgid/outreachy-kernel/2b8bde9c-6e84-48c5-ab93-
> 76127f314429%40googlegroups.com.
> For more options, visit https://groups.google.com/d/optout.
>
>
--8323329-1658514752-1504730395=:2984--
