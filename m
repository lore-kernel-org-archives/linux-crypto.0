From: Vinod <vkoul@kernel.org>
Subject: Re: [PATCH 2/2] hwrng: msm: add ACPI support
Date: Fri, 22 Jun 2018 10:18:20 +0530
Message-ID: <20180622044819.GJ27187@vkoul-mobl>
References: <1529594276-12210-1-git-send-email-timur@codeaurora.org>
 <1529594276-12210-2-git-send-email-timur@codeaurora.org>
 <20180622042322.GF27187@vkoul-mobl>
 <869e9828-5e34-49db-4387-629dcc4b09b0@codeaurora.org>
 <20180622044417.GI27187@vkoul-mobl>
 <30b28a05-dd63-603c-d4cd-296b84072faf@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: timur@kernel.org, linux-arm-msm@vger.kernel.org, swboyd@chromium.org,
 linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
 linux-arm-kernel@lists.infradead.org
To: Timur Tabi <timur@codeaurora.org>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <30b28a05-dd63-603c-d4cd-296b84072faf@codeaurora.org>
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

On 21-06-18, 23:46, Timur Tabi wrote:
> On 6/21/18 11:44 PM, Vinod wrote:
> > So this make me think you should do 2 level support for ACPI, one ACPI
> > support and one V2 support where we dont touch CONFIG register. That way
> > both regions will work
> 
> The ACPI system is a v2 system.  If you want, I can just remove the read of
> the CONFIG register.

Okay, so in this case who configures v2. My guess here is that firmware
hasn't locked access, default everyone can access per spec

-- 
~Vinod
