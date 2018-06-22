From: Stephen Boyd <swboyd@chromium.org>
Subject: Re: [PATCH 1/2] hwrng: msm: add a spinlock and support for blocking
 reads
Date: Fri, 22 Jun 2018 10:51:53 -0700
Message-ID: <152968991381.16708.522979730327886581@swboyd.mtv.corp.google.com>
References: <1529594276-12210-1-git-send-email-timur@codeaurora.org>
 <acc7e9d3-8a81-ff15-27c7-78ec7c17f6cc@linaro.org>
 <6d655b97-418e-bacf-7e88-b9179cdc6fd1@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matt Mackall <mpm@selenic.com>,
 Stanimir Varbanov <stanimir.varbanov@linaro.org>,
 Timur Tabi <timur@codeaurora.org>, linux-arm-kernel@lists.infradead.org,
 linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
 timur@kernel.org, vinod.koul@linaro.org
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <6d655b97-418e-bacf-7e88-b9179cdc6fd1@codeaurora.org>
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

Quoting Timur Tabi (2018-06-22 08:41:11)
> On 6/22/18 10:38 AM, Stanimir Varbanov wrote:
> > Before entering into the read function we already hold a mutex which
> > serializes data reading so I cannot imagine how below sequence could
> > happen. Can you explain how to reproduce this race?
> > 
> >> 1. Core 1 reads status register, shows data is available.
> >> 2. Core 2 also reads status register, same result
> >> 3. Core 2 reads data register, depleting all entropy
> >> 4. Core 1 reads data register, which returns 0
> 
> I have a test which spawns 100 copies of rngtest on a 48-core machine. 
> Without the spinlock, the driver returns no data much more often.
> 
> If there really is a mutex that serializes data reads across all cores, 
> then I don't have an explanation.
> 

Perhaps it's because you implemented the 'wait' functionality in this
driver? Before the patch there wasn't any sort of wait check so we would
bail out if there wasn't any data even if the caller requested that we
wait for randomness to be available.
