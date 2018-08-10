From: Caleb Raitto <caleb.raitto@gmail.com>
Subject: [PATCH net-next 2/2] virtio_net: Stripe queue affinities across cores.
Date: Thu,  9 Aug 2018 17:28:40 -0700
Message-ID: <20180810002840.186635-3-caleb.raitto@gmail.com>
References: <20180810002840.186635-1-caleb.raitto@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: arei.gonglei@huawei.com, jasowang@redhat.com,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        Caleb Raitto <caraitto@google.com>,
        Willem de Bruijn <willemb@google.com>
To: herbert@gondor.apana.org.au, mst@redhat.com, davem@davemloft.net
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180810002840.186635-1-caleb.raitto@gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Caleb Raitto <caraitto@google.com>

Always set the affinity hint, even if #cpu != #vq.

Handle the case where #cpu > #vq (including when #cpu % #vq != 0) and
when #vq > #cpu (including when #vq % #cpu != 0).

Signed-off-by: Caleb Raitto <caraitto@google.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
Acked-by: Jon Olson <jonolson@google.com>
---
 drivers/net/virtio_net.c | 42 ++++++++++++++++++++++++++--------------
 1 file changed, 27 insertions(+), 15 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 43fabc0eb4d2..eb00ae6ee475 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -31,6 +31,7 @@
 #include <linux/average.h>
 #include <linux/filter.h>
 #include <linux/netdevice.h>
+#include <linux/kernel.h>
 #include <linux/pci.h>
 #include <net/route.h>
 #include <net/xdp.h>
@@ -1888,30 +1889,41 @@ static void virtnet_clean_affinity(struct virtnet_info *vi, long hcpu)
 
 static void virtnet_set_affinity(struct virtnet_info *vi)
 {
-	int i;
-	int cpu;
+	cpumask_var_t mask;
+	int stragglers;
+	int group_size;
+	int i, j, cpu;
+	int num_cpu;
+	int stride;
 
-	/* In multiqueue mode, when the number of cpu is equal to the number of
-	 * queue pairs, we let the queue pairs to be private to one cpu by
-	 * setting the affinity hint to eliminate the contention.
-	 */
-	if (vi->curr_queue_pairs == 1 ||
-	    vi->max_queue_pairs != num_online_cpus()) {
+	if (!zalloc_cpumask_var(&mask, GFP_KERNEL)) {
 		virtnet_clean_affinity(vi, -1);
 		return;
 	}
 
-	i = 0;
-	for_each_online_cpu(cpu) {
-		const unsigned long *mask = cpumask_bits(cpumask_of(cpu));
+	num_cpu = num_online_cpus();
+	stride = max_t(int, num_cpu / vi->curr_queue_pairs, 1);
+	stragglers = num_cpu >= vi->curr_queue_pairs ?
+			num_cpu % vi->curr_queue_pairs :
+			0;
+	cpu = cpumask_next(-1, cpu_online_mask);
 
-		virtqueue_set_affinity(vi->rq[i].vq, cpumask_of(cpu));
-		virtqueue_set_affinity(vi->sq[i].vq, cpumask_of(cpu));
-		__netif_set_xps_queue(vi->dev, mask, i, false);
-		i++;
+	for (i = 0; i < vi->curr_queue_pairs; i++) {
+		group_size = stride + (i < stragglers ? 1 : 0);
+
+		for (j = 0; j < group_size; j++) {
+			cpumask_set_cpu(cpu, mask);
+			cpu = cpumask_next_wrap(cpu, cpu_online_mask,
+						nr_cpu_ids, false);
+		}
+		virtqueue_set_affinity(vi->rq[i].vq, mask);
+		virtqueue_set_affinity(vi->sq[i].vq, mask);
+		__netif_set_xps_queue(vi->dev, cpumask_bits(mask), i, false);
+		cpumask_clear(mask);
 	}
 
 	vi->affinity_hint_set = true;
+	free_cpumask_var(mask);
 }
 
 static int virtnet_cpu_online(unsigned int cpu, struct hlist_node *node)
-- 
2.18.0.597.ga71716f1ad-goog
