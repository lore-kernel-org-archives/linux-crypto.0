From: David McCullough <David_Mccullough@securecomputing.com>
Subject: Re: Openswan 2.4.9 - tasklet or workqueue ?
Date: Mon, 5 Nov 2007 13:35:46 +1000
Message-ID: <20071105033545.GA11607@securecomputing.com>
References: <43810.2490.qm@web62505.mail.re1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, ocf-linux-users@lists.sourceforge.net
To: Eran Ben-Avi <eranpublic@yahoo.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rex.snapgear.com ([203.143.235.140]:47487 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753047AbXKEDem (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 4 Nov 2007 22:34:42 -0500
Content-Disposition: inline
In-Reply-To: <43810.2490.qm@web62505.mail.re1.yahoo.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


Jivin Eran Ben-Avi lays it down ...
...
> > I have made a few small changes to your patch so it should be safe on
> > 2.4 systems yet still select tasklets on 2.6 automatically.
> > 
> > Could you have a look at it ?  I have done some basic testing here
> > and it seems ok,  haven't checked your performance increases yet ;-)
> > 
> Sorry for the late response.
> It seems to be ok. I will test it more intensely in the next few days.


No problems,  I have it sitting there ready to go :-)

Cheers,
Davidm

> > -----Inline Attachment Follows-----
> > 
> > Index: openswan/linux/include/openswan/ipsec_rcv.h
> > ===================================================================
> > RCS file: openswan/linux/include/openswan/ipsec_rcv.h,v
> > retrieving revision 1.13
> > diff -u -r1.13 ipsec_rcv.h
> > --- openswan/linux/include/openswan/ipsec_rcv.h    26 Jun 2007
> > 06:28:52
> > 
>  -0000    1.13
> > +++ openswan/linux/include/openswan/ipsec_rcv.h    26 Sep 2007
> > 14:17:25
> > 
>  -0000
> > @@ -149,6 +149,9 @@
> >  
> >  #ifdef CONFIG_KLIPS_OCF
> >      struct work_struct    workq;
> > +#ifdef DECLARE_TASKLET
> > +    struct tasklet_struct    tasklet;
> > +#endif
> >  #endif
> >  #ifndef NET_21
> >      struct net_device *devp;
> > Index: openswan/linux/include/openswan/ipsec_xmit.h
> > ===================================================================
> > RCS file: openswan/linux/include/openswan/ipsec_xmit.h,v
> > retrieving revision 1.9
> > diff -u -r1.9 ipsec_xmit.h
> > --- openswan/linux/include/openswan/ipsec_xmit.h    26 Jun
> > 2007
> > 
>  05:26:25 -0000    1.9
> > +++ openswan/linux/include/openswan/ipsec_xmit.h    26 Sep
> > 2007
> > 
>  14:17:25 -0000
> > @@ -140,6 +140,9 @@
> >      int        next_state;
> >  #ifdef CONFIG_KLIPS_OCF
> >      struct work_struct    workq;
> > +#ifdef DECLARE_TASKLET
> > +    struct tasklet_struct    tasklet;
> > +#endif
> >  #endif
> >  #ifdef CONFIG_KLIPS_ALG
> >      struct ipsec_alg_auth *ixt_a;
> > Index: openswan/linux/net/ipsec/ipsec_ocf.c
> > ===================================================================
> > RCS file: openswan/linux/net/ipsec/ipsec_ocf.c,v
> > retrieving revision 1.27
> > diff -u -r1.27 ipsec_ocf.c
> > --- openswan/linux/net/ipsec/ipsec_ocf.c    11 Jul 2007 00:35:01
> > -0000
> > 
>     1.27
> > +++ openswan/linux/net/ipsec/ipsec_ocf.c    26 Sep 2007 14:17:25 -0000
> > @@ -56,7 +56,11 @@
> >  #define USE_BATCH 1    /* enable batch mode */
> >  #define USE_CBIMM 1    /* enable immediate callbacks */
> >  #define FORCE_QS  0    /* force use of queues for continuation
> > of
> > 
>  state machine */
> > -
> > +#ifdef DECLARE_TASKLET
> > +#define USE_TASKLET 1  /* use tasklet for continuation of
> > state
> > 
>  machine */
> > +#else
> > +#define USE_TASKLET 0  /* don't use tasklet for continuation of
> > state
> > 
>  machine */
> > +#endif
> >  /*
> >   * Because some OCF operations are synchronous (ie.,
> > software
> > 
>  encryption)
> >   * we need to protect ourselves from distructive re-entry.  All we do
> > @@ -83,15 +87,21 @@
> >          (*sm)(arg); \
> >      })
> >  
> > -#if FORCE_QS == 0
> > -    #define PROCESS_NEXT(wq, wqsm, sm, arg) \
> > +#if USE_TASKLET == 1
> > +    #define PROCESS_NEXT(this, wqsm, sm) ({ \
> > +        tasklet_init(&this->tasklet, \
> > +            (void (*)(unsigned long)) sm, (unsigned long)this); \
> > +        tasklet_schedule(&this->tasklet); \
> > +        })
> > +#elif FORCE_QS == 0
> > +    #define PROCESS_NEXT(this, wqsm, sm) \
> >          if (in_interrupt()) { \
> > -            PROCESS_LATER(wq, wqsm, arg); \
> > +            PROCESS_LATER(this->workq, wqsm, this); \
> >          } else { \
> > -            PROCESS_NOW(sm, arg); \
> > +            PROCESS_NOW(sm, this); \
> >          }
> >  #else
> > -    #define PROCESS_NEXT(wq, wqsm, sm, arg) PROCESS_LATER(wq,
> > wqsm,
> > 
>  arg)
> > +    #define PROCESS_NEXT(this, wqsm, sm)
> > PROCESS_LATER(this->workq,
> > 
>  wqsm, this)
> >  #endif
> >  
> >  /*
> > @@ -218,6 +228,7 @@
> >      return 1;
> >  }
> >  
> > +#if USE_TASKLET == 0
> >  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20)
> >  static void
> >  ipsec_rsm_wq(struct work_struct *work)
> > @@ -228,6 +239,7 @@
> >  #else
> >  #define    ipsec_rsm_wq    ipsec_rsm
> >  #endif
> > +#endif /* USE_TASKLET */
> >  
> >  static int
> >  ipsec_ocf_rcv_cb(struct cryptop *crp)
> > @@ -235,7 +247,6 @@
> >      struct ipsec_rcv_state *irs = (struct
> > ipsec_rcv_state
> > 
>  *)crp->crp_opaque;
> >  
> >      KLIPS_PRINT(debug_rcv, "klips_debug:ipsec_ocf_rcv_cb\n");
> > -
> >      if (irs == NULL) {
> >          KLIPS_PRINT(debug_rcv, "klips_debug:ipsec_ocf_rcv_cb: "
> >                  "NULL irs in callback\n");
> > @@ -273,7 +284,7 @@
> >      crp = NULL;
> >  
> >      /* setup the rest of the processing now */
> > -    PROCESS_NEXT(irs->workq, ipsec_rsm_wq, ipsec_rsm, irs);
> > +    PROCESS_NEXT(irs, ipsec_rsm_wq, ipsec_rsm);
> >      return 0;
> >  }
> >  
> > @@ -396,6 +407,7 @@
> >      return(IPSEC_RCV_PENDING);
> >  }
> >  
> > +#if USE_TASKLET == 0
> >  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20)
> >  static void
> >  ipsec_xsm_wq(struct work_struct *work)
> > @@ -406,6 +418,7 @@
> >  #else
> >  #define    ipsec_xsm_wq    ipsec_xsm
> >  #endif
> > +#endif /* USE_TASKLET */
> >  
> >  static int
> >  ipsec_ocf_xmit_cb(struct cryptop *crp)
> > @@ -445,7 +458,7 @@
> >      crp = NULL;
> >  
> >      /* setup the rest of the processing now */
> > -    PROCESS_NEXT(ixs->workq, ipsec_xsm_wq, ipsec_xsm, ixs);
> > +    PROCESS_NEXT(ixs, ipsec_xsm_wq, ipsec_xsm);
> >      return 0;
> >  }
> >  
> > 
> > 
> 
> 
> 
> __________________________________________________
> Do You Yahoo!?
> Tired of spam?  Yahoo! Mail has the best spam protection around 
> http://mail.yahoo.com
> 

-- 
David McCullough,  david_mccullough@securecomputing.com,   Ph:+61 734352815
Secure Computing - SnapGear  http://www.uCdot.org http://www.cyberguard.com
