From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH v2 net-next 0/2] virtio_net: Expand affinity to
 arbitrary numbers of cpu and vq
Date: Sat, 11 Aug 2018 12:03:24 -0700 (PDT)
Message-ID: <20180811.120324.88920967254643809.davem@davemloft.net>
References: <20180810011828.199888-1-caleb.raitto@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, mst@redhat.com,
        arei.gonglei@huawei.com, jasowang@redhat.com,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        caraitto@google.com
To: caleb.raitto@gmail.com
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180810011828.199888-1-caleb.raitto@gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Caleb Raitto <caleb.raitto@gmail.com>
Date: Thu,  9 Aug 2018 18:18:27 -0700

> Virtio-net tries to pin each virtual queue rx and tx interrupt to a cpu if
> there are as many queues as cpus.
> 
> Expand this heuristic to configure a reasonable affinity setting also
> when the number of cpus != the number of virtual queues.
> 
> Patch 1 allows vqs to take an affinity mask with more than 1 cpu.
> Patch 2 generalizes the algorithm in virtnet_set_affinity beyond
> the case where #cpus == #vqs.
> 
> v2 changes:
> Renamed "virtio_net: Make vp_set_vq_affinity() take a mask." to
> "virtio: Make vp_set_vq_affinity() take a mask."
> 
> Tested:
 ...

Yes, this is so much better than the NAPI module parameter thing!

I'll apply this, and we can adjust/tweak the logic if necessary
on top of these changes.

Thanks!
