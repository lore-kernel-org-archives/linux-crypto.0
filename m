From: Pravin Shelar <pshelar@ovn.org>
Subject: Re: [ovs-dev] [PATCH 7/8] net: ovs: remove unused hardirq.h
Date: Thu, 7 Dec 2017 11:27:29 -0800
Message-ID: <CAOrHB_CiK-A0nphB2xVTG_5P_xeFOkg0xc6iNNbT=MXq1XgU=A@mail.gmail.com>
References: <1510959741-31109-1-git-send-email-yang.s@alibaba-inc.com> <1510959741-31109-7-git-send-email-yang.s@alibaba-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-kernel@vger.kernel.org, ovs dev <dev@openvswitch.org>,
	Linux Kernel Network Developers <netdev@vger.kernel.org>, linux-mm@kvack.org,
	Pravin Shelar <pshelar@nicira.com>, linux-crypto@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
To: Yang Shi <yang.s@alibaba-inc.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1510959741-31109-7-git-send-email-yang.s@alibaba-inc.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Nov 17, 2017 at 3:02 PM, Yang Shi <yang.s@alibaba-inc.com> wrote:
> Preempt counter APIs have been split out, currently, hardirq.h just
> includes irq_enter/exit APIs which are not used by openvswitch at all.
>
> So, remove the unused hardirq.h.
>
> Signed-off-by: Yang Shi <yang.s@alibaba-inc.com>
> Cc: Pravin Shelar <pshelar@nicira.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: dev@openvswitch.org

Acked-by: Pravin B Shelar <pshelar@ovn.org>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
