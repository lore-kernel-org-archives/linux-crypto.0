From: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 0/6] Various ux500 crypto updates
Date: Tue, 25 Jun 2013 11:20:50 +0200
Message-ID: <CACRpkdYgZ5ZSwDBfV8FRRqGcv09JiFyNq18vqO_dbxbhJ6_x4w@mail.gmail.com>
References: <1372150489-25594-1-git-send-email-fabio.baltieri@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Lee Jones <lee.jones@linaro.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1372150489-25594-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jun 25, 2013 at 10:54 AM, Fabio Baltieri
<fabio.baltieri@linaro.org> wrote:

> these are some fixes to issue pointed out by sparse and dmaengine API
> udpates on the recently enabled ux500 hw crypto drivers.

The series:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

> These are based on recent linux-next, and can probably be applied on an
> architecture specific branch with your ack, or just skip to the next
> merge window.

I think these depend on the DMA40 fixes that reside in the ARM SoC
tree. If I get Herbert's ACK I can queue them.

They will have to go through that tree or wait for the next merge
window, I think they are not regressions so no hurry.

Yours,
Linus Walleij
